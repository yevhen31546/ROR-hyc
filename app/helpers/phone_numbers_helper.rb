module PhoneNumbersHelper
  # build upon the builtin number_to_phone method in rails
  # http://api.rubyonrails.org/classes/ActionView/Helpers/NumberHelper.html#method-i-number_to_phone
  def format_phone_number(str)
    str.gsub!(/[\-\s\+]/, '')
    country_code = nil

    # some wise guy added on a 353 country code
    if str =~ /^353/
      str.gsub!(/^(353)/, '')
      country_code = '353'
    end

    return number_to_phone(str, delimiter: ' ', area_code: true, country_code: country_code)
  end
end