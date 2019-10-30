require 'csv'

class Admin::OrdersController < Admin::BaseController
  resource_controller

  respond_to :html, :csv

  def export

    @orders = Order.paid.order('created_at desc').limit(1000)
    if params[:date].present?
      date = Date.parse(params[:date])
      range = date.to_s("%d")
      @orders = @orders.where("DATE(created_at) = ?", date)
    else
      range = 'recent'
      date = 6.months.ago
      @orders = @orders.where("created_at > ?", date)
    end


    headers['Content-Disposition'] = 'attachment; filename="orders_for_'+range+'_generated_'+Time.now.strftime("%d-%m-%Y-%H%M%S")+'.csv"'
    headers['Cache-Control'] = ''


    exportable_headers = [
      [:id, 'Reference'],
      [:member_name, 'Member Name'],
      [:member_id, 'Member ID'],
      [:email, 'Email'],
      [:payment_item_id, 'Payment Reference'],
      [:total, 'Total'],
    ]

    @product_categories = ProductCategory.order('position asc').includes(:products)
    @product_categories.each do |cat|
      cat.products.each do |p|
        exportable_headers << [:"product_#{p.id}", p.name]
      end
    end

    exportable_headers += [
      [:payment_status_human, 'Status'],
      [:created_at, "Date"]
    ]

    csv_string = CSV.generate do |csv|
      csv << exportable_headers.map { |header| header[1] }

      @orders.each do |order|
        row = []

        order_product_details = {}
        order.order_items.map do |oi|
          order_product_details[oi.product_id] = oi.amount
        end

        exportable_headers.each do |key, header|
          if key =~ /product_/
            product_id = key.to_s.gsub(/\D/, '').to_i
            if order_product_details[product_id]
              row << order_product_details[product_id]
            else
              row << nil
            end
          else
            row << order.send(key)
          end
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
    end_of_association_chain.paid.order('created_at desc').page(params[:page])
  end
end
