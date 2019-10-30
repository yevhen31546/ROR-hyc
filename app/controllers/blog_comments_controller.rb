class BlogCommentsController < ApplicationController
  resource_controller

  create do
    before do
      object.ip = request.remote_ip
      object.status = 'unapproved'
    end
    flash 'Comment submitted. Your comment will appear when it has been approved by an admin.'
    wants.html { redirect_to object.blog_post; }    
  end

  def show
    redirect_to "#{blog_post_path(object.blog_post)}#comment-#{object.id}"; return
  end

  private
  def collection
    end_of_association_chain.approved.page(params[:page])
  end
end
