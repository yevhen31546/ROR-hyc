class Admin::ContactsController < Admin::BaseController
  resource_controller

  def show
    redirect_to :action => 'index'
  end

  def update_positions
    begin
      ids = params[:ids]
      raise "ids is nil" unless ids
      ids.each_with_index do |id, index|
        Contact.find(id).update_attribute(:sort_order, index)
      end
      head :ok
    rescue
      Rails.logger.error $!
      Rails.logger.error $!.backtrace
      head :bad_request
    end
  end

private

  def collection
    end_of_association_chain.page(params[:page])
  end
end
