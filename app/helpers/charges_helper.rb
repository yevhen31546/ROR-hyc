module ChargesHelper

  # used in entries and admin/entries when 
  def preprocess_charges_params
    if params[:entry] && params[:entry][:charges_accepted].present?
      if params[:entry][:charges_accepted].is_a?(Array)
        params[:entry][:charges_accepted] = params[:entry][:charges_accepted].map do |ff|
          Charge.find(ff) 
        end
      elsif params[:entry][:charges_accepted].is_a?(Hash)
        params[:entry][:charges_accepted] = params[:entry][:charges_accepted].map do |key, ff|
          if ff == '1' or key == ff # checkbox or other
            charge_id = key.to_i
          elsif key.to_i > 0 && (ctmp = Charge.find_by_id(key)) && ctmp.charge_type == 'Quantity' # quantity
            # when this is a quantity, it looks like {"75" => "2"} - {"charge_id" => "quantity"}
            # the quantity could be zero so we need to ignore that
            charge_id = key.to_i
            quantity = ff.to_i
            # put this into charge_values, we will create a charge for the model later
            params[:entry][:charge_values] ||= ActiveSupport::HashWithIndifferentAccess.new
            params[:entry][:charge_values][charge_id] = quantity
          else
            charge_id = ff.to_i
          end
          Charge.find(charge_id) 
        end
      end
    end
  end

  # this is used to handle an update to charges made in the admin/entries
  def preprocess_charges_params_updates(entry)
    if params[:entry] && params[:entry][:charges_accepted].present?
      entry.charges_entries = []
      if params[:entry][:charges_accepted].is_a?(Array)
        params[:entry][:charges_accepted].each do |ff|
          entry.charges_entries << ChargeEntry.new(:charge_id => ff)
        end
      elsif params[:entry][:charges_accepted].is_a?(Hash)
        params[:entry][:charges_accepted] = params[:entry][:charges_accepted].map do |key, ff|
          if ff == '1' or key == ff # checkbox or other
            charge_id = key.to_i
          elsif key.to_i > 0 && (ctmp = Charge.find_by_id(key)) && ctmp.charge_type == 'Quantity' # quantity
            charge_id = key.to_i
            quantity = ff.to_i
          else
            charge_id = ff.to_i
          end
          entry.charges_entries << ChargeEntry.new(:charge_id => charge_id, :quantity => quantity || 1) 
        end
      end
      params[:entry].delete(:charges_accepted)
    end
    entry
  end

end