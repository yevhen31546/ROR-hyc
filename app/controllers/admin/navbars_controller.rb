class Admin::NavbarsController < Admin::BaseController
  resource_controller

  def index
    redirect_to :action => 'edit', :id => Navbar.find_by_code('main'); return
  end

  def navbar
    @navbar = Navbar.find(params[:id])
    render :partial => 'navbar'
  end
  
  show.response do |wants|
    wants.html
    wants.json { render :json => @navbar.to_jstree_json }
  end

  def update_position
    move_type = params[:type]
    navbar_id = params[:id]
    ref_item = NavbarItem.find(params[:ref_node])
    moving_item = NavbarItem.find(params[:node])

    if ['after', 'before'].include?(move_type)
      # get current order of items on this level
      items = NavbarItem.find(:all, :conditions =>
          {:navbar_id => navbar_id, :parent_id => ref_item.parent_id})

      # remove moved item from list if its there
      items.reject!{|item| item == moving_item}

      # add the moved item back in in the correct position
      index_of_ref_item = items.index(ref_item)

      if index_of_ref_item
        case move_type
        when 'after'
          items.insert(index_of_ref_item+1, moving_item)
        when 'before'
          items.insert(index_of_ref_item, moving_item)
        end
      else
        items.insert(0, moving_item)
      end
      
      # set the parent id
      moving_item.update_attribute(:parent_id, ref_item.parent_id)
    elsif ['inside', 'first', 'last'].include?(move_type)
      # get current order of items on this level
      if ref_item
        items = NavbarItem.find(:all, :conditions =>
            {:navbar_id => navbar_id, :parent_id => ref_item.id})
        items.unshift(moving_item)
      end

      # set the parent id
      moving_item.update_attribute(:parent_id, ref_item.id)
    end

    # rewrite the positions for this level
    unless items.empty?
      i = 0
      items.each do |item|
        item.update_attribute(:position, i+=1)
      end
      render :json => true
    else
      render :json => true, :status => 500
    end

  end

end
