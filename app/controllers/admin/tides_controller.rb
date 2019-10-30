class Admin::TidesController < Admin::BaseController
  resource_controller

  def show
    redirect_to :action => :index
  end

  def add_multiple
    if params[:tides].present?
      @num_tides = 0
      params[:tides].lines.each do |line|
        tide_date_at, tide_time_at, height = line.split(',')
        begin
          Rails.logger.debug [tide_date_at, tide_time_at, height].inspect
          tide_at = Time.parse("#{tide_date_at} #{tide_time_at}")
          tide = Tide.new(:tide_at => tide_at, :height => height)
          @num_tides += 1 if tide.save
        rescue ArgumentError
          Rails.logger.debug "Couldn't parse #{line}"
        end
      end
    end
  end

  def delete_multiple
    tides = Tide.where(:id => params[:ids])
    if tides.present?
      tides.delete_all
    end
    redirect_to admin_tides_path
  end


  def delete_by_year
    year = params[:year]
    if year.present?
      tides = Tide.where(
        "date(tide_at) >= ? AND date(tide_at) <= ?",
        Date.new(year.to_i, 1, 1),
        Date.new(year.to_i, 12, 31)
      ).delete_all
    end
    redirect_to admin_tides_path
  end

  private
  def collection
    end_of_association_chain.order('tide_at desc').
      page(params[:page]).
      per(1460)
  end
end
