module EntriesHelper

  def sortable_column_link_to(link_title, column_attr)

    selected = (@selected_column_attr == column_attr)
    Rails.logger.debug @selected_column_attr
    class_name = (selected ? "active_sort_column active_sort_column_#{@order_dir}" : 'inactive_sort_column')
    class_name << " sortable_column"
    order_dir = (selected ? @reverse_order_dir : @order_dir)

    link_to link_title, url_for(:order => column_attr, :order_dir => order_dir, :event_id => params[:event_id]), :class => class_name
  end

end
