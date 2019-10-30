xml.instruct!

xml.rss "version" => "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom" do  # Atom namespace required by the W3C feed validator
 xml.channel do
   xml.title    "#{get_site_name} Blog"
   xml.description "Updates from the #{get_site_name} Blog"
   xml.link        request.url
   xml.pubDate     @blog_posts.max_by {|post| post.created_at }.created_at.to_s(:rfc822)
   xml.tag!("atom:link", :href => request.url, :rel => "self", :type => "application/rss+xml")

   @blog_posts.each do |blog_post|
     xml.item do
       xml.title       blog_post.title
       xml.description blog_post.content.gsub(/style=\".*\"/, '')
       xml.pubDate     blog_post.created_at.to_s(:rfc822)
       xml.link        blog_post_path(blog_post, :only_path => false)
       xml.guid        blog_post_path(blog_post, :only_path => false)
       #xml.author blog_post.author
       #xml.category blog_post.blog_category.name
     end
   end
 end
end