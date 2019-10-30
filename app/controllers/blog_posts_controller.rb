class BlogPostsController < ApplicationController
  resource_controller

  index.response do |wants|
    wants.html
    wants.rss { render :layout => false }
    wants.atom { render :layout => false }
  end  

private
  def collection
    collection = end_of_association_chain
    collection = collection.where(:blog_category_id => selected_blog_category_id) if params[:blog_category_id].present?
    collection.page(params[:page])
  end
  
end
