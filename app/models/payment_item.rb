require 'base64'

class PaymentItem < ActiveRecord::Base
  attr_accessor :card_number, :card_security_code, :gateway_config  # not saved in database for security reasons
  attr_protected :user_agent, :ip_address, :amount, :currency       # must be securely overwritten in controller
  belongs_to :product, :polymorphic => true

  # validate :card_validation, :unless => Proc.new { |f| f.errors.size > 0 || f.payment_method == 'paypal' || f.authorization.present? }

  before_validation :ensure_payment_id

  def init_credit_card
    if self.card_number == 'test' && !Rails.env.production?
      self.card_number = '4929000000006'
      self.expiry_month = '12'
      self.expiry_year = '2030'
      self.card_security_code = '123'
      self.name_on_card = 'Test Test'
    end

    if self.card_number.present?
      self.card_number = self.card_number.gsub(/\D+/, '').gsub(/\s*(\d{4})/, '\1 ').strip # reformat number
      self.last_digits = self.card_number.gsub(/\D+/, '')[-4,4]
    end

    @credit_card = ActiveMerchant::Billing::CreditCard.new(
      number:             self.card_number,
      month:              self.expiry_month,
      year:               self.expiry_year,
      first_name:         self.name_on_card.try(:split).try(:[], 0).to_s,
      last_name:          self.name_on_card.try(:split).try(:[], 1..-1).try(:to_a).try(:join, ' '),
      verification_value: self.card_security_code
    )
  end

  def card_validation
    init_credit_card
    field_translation = {'month' => 'expiry_month', 'year' => 'expiry_year', 'number' => 'card_number',
                         'type' => 'payment_method', 'first_name' => nil, 'last_name' => 'name_on_card', 'verification_value' => 'card_security_code'}
    @credit_card.valid?
    @credit_card.errors.each do |e|
      translated_field = field_translation[e[0]]
      error_message = e[1].to_a.join(' and ')
      next if translated_field.blank? or error_message.blank?
      next if translated_field == 'payment_method'
      next if [translated_field, self.payment_method] == ['card_security_code', 'laser']
      error_message = 'is missing last name' if translated_field == 'name_on_card' && !self.name_on_card.blank?
      error_message = 'is now past expiry date' if translated_field == 'expiry_year' && error_message =~ /expired/i
      errors.add translated_field, error_message
    end
  end

  def init_gateway
    unless Rails.env.production?
      ActiveMerchant::Billing::Base.mode = :test
    end

    @gateway = ActiveMerchant::Billing::Realex3dsGateway.new(GATEWAY_CONFIG)
  end

  def ensure_payment_id
    self.payment_id ||= generate_payment_id
  end

  def generate_payment_id
    return "#{(Rails.env.production? ? '' : 'dev-')}#{Time.now.strftime('%Y%m%d')}-#{rand(36**4).to_s(36).upcase.tr('01IlO', '23456')}"
  end

  def payment_validation
    init_gateway
    self.payment_method = @credit_card.type

    money = (self.amount.to_f * 100).round
    options = { order_id: self.payment_id, currency: self.currency, :description => description, :customer => customer, :invoice => invoice, :varref => varref }.delete_if { |k,v| v.blank? }

    auth_resp = @gateway.authorize(money, @credit_card, options)
    handle_gateway_response(auth_resp)

    self.authorization = auth_resp.authorization

    capture_resp = @gateway.capture(money, authorization, options)
    handle_gateway_response(capture_resp)
  end

  def authorize
    init_gateway
    self.payment_method = @credit_card.brand

    money = (self.amount.to_f * 100).round
    options = { order_id: self.payment_id, currency: self.currency, :description => description, :three_d_secure => true, :customer => customer, :invoice => invoice, :varref => varref }.delete_if { |k,v| v.blank? }

    resp = @gateway.authorize(money, @credit_card, options)
    Rails.logger.info resp.inspect
    resp
  end

  def capture(extra_options = nil)
    init_gateway

    return false unless self.authorization

    # raise self.payment_id.inspect
    money = (self.amount.to_f * 100).round
    options = { order_id: self.payment_id, currency: self.currency, :description => description, :customer => customer, :invoice => invoice, :varref => varref }.delete_if { |k,v| v.blank? }

    if extra_options
      options.merge(extra_options)
    else
      options[:three_d_secure] = true
    end

    resp = @gateway.capture(money, self.authorization, options)
    Rails.logger.info resp.inspect
    resp
  end

  # do authorize and capture in one go
  def purchase(extra_options = nil)
    init_gateway
    self.payment_method = @credit_card.brand

    money = (self.amount.to_f * 100).round
    options = { order_id: self.payment_id, currency: self.currency, :description => description, :customer => customer, :invoice => invoice, :varref => varref }.delete_if { |k,v| v.blank? }

    if extra_options
      options.merge(extra_options)
    else
      options[:three_d_secure] = true
    end

    resp = @gateway.purchase(money, @credit_card, options)
    Rails.logger.info resp.inspect
    resp
    puts resp.params["pasref"]
    self.pas_ref=resp.params["pasref"]
    self.batch_id =resp.params["batchid"]
    self.save
    resp
  end

  def repeat_payment
    init_gateway

    money = (self.amount.to_f * 100).round
    options = { order_id: self.payment_id, currency: self.currency }

    repeat_resp = @gateway.repeat(money, authorization, options)
    handle_gateway_response(repeat_resp)
  end

  def handle_gateway_response(response)
    resp_error = "processing error: #{response.message}"
    resp_error << " #{response.params['message']}" if response.params['message'].present? && payment_method != 'Realex'
    resp_error << " (#{response.params['result']})" if response.params['result'].present?
    unless response.success?
      errors.add 'card', resp_error; return;
    end
  end

  def description
    if product
      if product.is_a?(Entry) && product.event
        return product.event.title
      elsif product.is_a?(Order)
        return "Members Account"
      elsif product.is_a?(CraneHireBooking)
        return "Crane Hire - #{product.id}"
      end
    end
  end

  def customer
    if product
      if product.is_a?(Entry) && product.owner_name.present?
        return product.owner_name.gsub(/[^\d\w\-_\.,\+@\s]/, '')
      elsif product.is_a?(Order)
        return product.member_id.gsub(/\//, '-').gsub(/[^\d\w\-_\.,\+@\s]/, '')
      end
    end
  end

  def invoice
    if product
      if product.is_a?(Entry) && product.boat_name.present?
        return product.boat_name.gsub(/[^\d\w\-_\.,\+@\s]/, '')
      elsif product.is_a?(Order)
        return product.reference
      end
    end
  end

  def varref
    vref = nil
    if product
      if product.is_a?(Entry) && product.event
        vref = product.event.title_with_year
      elsif product.is_a?(Order)
        vref = product.reference
      end
    end
    vref = vref.gsub(/\//, '-').gsub(/[^\d\w\-_\.,\+@\s]/, '')[0,50] if vref
    vref
  end

  # generate an encryption salt value that
  def generate_enc_salt!
    self.enc_salt = Time.now.to_i.to_s
    self.enc_iv = Base64.encode64(OpenSSL::Cipher::Cipher.new('aes-256-cbc').random_iv)
    Rails.logger.debug self.enc_iv
    save!
  end

  def encrypt_md
    generate_enc_salt! unless enc_iv

    raise "No credit card set!" unless @credit_card

    raw_md = "#{@credit_card.number}.#{@credit_card.month}.#{@credit_card.year}.#{@credit_card.first_name}.#{@credit_card.last_name}.#{@credit_card.verification_value}.#{@credit_card.brand}"
    Rails.logger.debug raw_md.inspect
    enc_md = Encryptor.encrypt(raw_md, :key => MD_ENCRYPTION_KEY, :iv => Base64.decode64(enc_iv), :salt => enc_salt)
    Rails.logger.debug enc_md.inspect
    enc_md = Base64.encode64(enc_md) # convert to base64 because I had problems with utf encoding when its put into a html form
    enc_md.gsub!("\n", '___') # remove new lines
    enc_md
    Rails.logger.debug enc_md.inspect

    return enc_md
  end

  def decrypt_md(enc_md)
    enc_md.gsub!("___", "\n") # add new lines back in
    enc_md = Base64.decode64(enc_md)
    Rails.logger.debug enc_md.inspect
    Rails.logger.debug enc_iv
    Rails.logger.debug Base64.decode64(enc_iv)
    md_str = Encryptor.decrypt(enc_md, :key => MD_ENCRYPTION_KEY, :iv => Base64.decode64(enc_iv), :salt => enc_salt)

    credit_card_parts = md_str.split('.')
    Rails.logger.debug credit_card_parts.inspect

    @credit_card = ActiveMerchant::Billing::CreditCard.new(
      number:             credit_card_parts[0],
      month:              credit_card_parts[1],
      year:               credit_card_parts[2],
      first_name:         credit_card_parts[3],
      last_name:          credit_card_parts[4],
      verification_value: credit_card_parts[5]
    )
    @credit_card.brand = credit_card_parts[6]

    return true
  end

end
