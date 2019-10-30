require 'csv'

class Admin::CrewFinderAdsController < Admin::BaseController
  resource_controller

  def show
    redirect_to :action => 'index'
  end

  def export
    @crew_finder_ads = collection

    # headers['Content-Disposition'] = 'attachment; filename="crew_finder_ads_'+@selected_ad_type+'_'+Time.now.strftime("%d-%m-%Y-%H%M%S")+'.csv"'
    # headers['Cache-Control'] = ''

    exportable_headers = [
      [:id, 'Reference'],
      [:contact_name, 'Contact Name'],
      [:contact_email, 'Contact Email'],
      [:contact_phone, 'Contact Phone'],
      [:ad_type, 'Ad Type'],
    ]

    if ['all', 'available'].include?(@selected_ad_type)
      exportable_headers += [
        [:age, 'Age'],
        [:interested_in, 'Interested In'],
        [:availability, 'Availability'],
        [:preferred_position, 'Preferred Position(s)'],
        [:experience, 'Sailing Experience'],
      ]
    end

    if ['all', 'wanted'].include?(@selected_ad_type)
      exportable_headers += [
        [:description, 'Description'],
      ]
    end

    exportable_headers += [
      [:created_at, 'Date Posted']
    ]

    csv_string = CSV.generate do |csv|
      csv << exportable_headers.map { |header| header[1] }

      @crew_finder_ads.each do |ad|
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
    @selected_ad_type = (params[:ad_type].presence || 'all')
    page_param = params[:page].is_a?(HashWithIndifferentAccess) ? 1 : params[:page]
    @collection = end_of_association_chain.order('created_at desc').page(params[:page])
    @collection = @collection.where(ad_type: @selected_ad_type) if @selected_ad_type != 'all'
    @collection
  end
end
