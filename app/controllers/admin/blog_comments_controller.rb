class Admin::BlogCommentsController < Admin::BaseController
  resource_controller

  def show
    redirect_to :action => 'index'
  end  

  update do
    before do
      object.status = params[:blog_comment][:status]
    end
  end 

  def approve
    object.status = 'approved'
    object.save!
    redirect_to :action => 'index'
  end

private
  def collection
    end_of_association_chain.page(params[:page])
  end 
end
