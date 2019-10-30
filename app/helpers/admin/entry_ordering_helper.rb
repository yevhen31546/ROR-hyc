module Admin::EntryOrderingHelper

  def get_admin_entry_ordering
    @selected_column_attr = params[:order] || 'combined_class_sail_num'

    @order_dirs = ['asc', 'desc']
    @order_dir = (params[:order_dir] || @order_dirs.first)

    @order_dirs_copy = @order_dirs.dup
    @order_dirs_copy.delete(@order_dir)
    @reverse_order_dir = @order_dirs_copy.first

    allowable_orders = ['combined_class_sail_num', 'combined_fleet_sail_num', 'boat_classes.name', 'model', 'is_saturday_only_lambay', 'sail_number', 'boat_name', 'owner_name', 'clubs.name', 'created_at']
    @selected_column_attr = nil unless allowable_orders.include?(@selected_column_attr)

    if @selected_column_attr == 'sail_number'
      @order = "CAST(sail_number AS UNSIGNED)"
    elsif @selected_column_attr == 'combined_class_sail_num'
      @order = "boat_classes.name #{@order_dir}, CAST(sail_number AS UNSIGNED)"
    elsif @selected_column_attr == 'combined_fleet_sail_num'
      @order = "fleets.name #{@order_dir}, CAST(sail_number AS UNSIGNED)"
    else
      @order = @selected_column_attr
    end

    [@order, @order_dir]
  end

end
