require 'csv'

class Admin::EnquiriesController < Admin::BaseController
  resource_controller

 def export
    @enquiries = collection

    headers['Content-Disposition'] = 'attachment; filename="enquiries_'+Time.now.strftime("%d-%m-%Y-%H%M%S")+'.csv"'
    headers['Cache-Control'] = ''

    exportable_headers = [
      [:id, 'Reference'],
      [:name, 'Name'],
      [:email, 'Email'],
      [:phone, 'Phone'],
      [:hyc_member, 'HYC Member'],
      [:function_date, 'Function Date'],
      [:arrival_time, 'Arrival Time'],
      [:num_attendees, 'Number of Attendees'],
      [:function_type, 'Function Type'],
      [:menu, 'Menu'],
      [:message, 'Other Details'],
      [:created_at, 'Created']
    ]

    csv_string = CSV.generate do |csv|
      csv << exportable_headers.map { |header| header[1] }

      @enquiries.each do |ad|
        row = []
        exportable_headers.each do |key, header|
          row << (ad.send(key).is_a?(String) ? ad.send(key).gsub(/\r?\n/, ' ') : ad.send(key))
        end

        csv << row
      end
    end

    respond_to do |format|
      format.csv { render text: csv_string }
    end
  end

  private
  def collection
    @collection ||= ContactUs.order("created_at desc").page(params[:page])
  end

  def object
    @object ||= ContactUs.find(param)
  end
end
