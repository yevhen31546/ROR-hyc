class Admin::PagesController < Admin::BaseController
  resource_controller

  def show
    redirect_to :action => 'index'
  end

  private
  def collection
    page_param = params[:page].is_a?(HashWithIndifferentAccess) ? 1 : params[:page]

    @collection = end_of_association_chain

    # search
    if (@query = params[:query]).present?
      @collection = @collection.by_query(@query, ['pages.title'])
    end

    # limit by role
    if !is_admin?
      @collection = @collection.by_role(current_user.role)
    end

    @collection = @collection.page(params[:page])
  end

  def build_object
    @object ||= begin
      if params[:copy_id].present?
        Page.find(params[:copy_id]).clone
      else
        end_of_association_chain.send parent? ? :build : :new, object_params
      end
    end
  end
end
