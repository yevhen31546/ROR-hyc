atom_feed do |feed|
  feed.title    "#{get_site_name} Blog"
  feed.updated  @most_recent

  @blog_posts.each do |blog_post|
    feed.entry(blog_post) do
      feed.title     blog_post.title
      feed.content   blog_post.content
      feed.updated   blog_post.updated_at#.strftime("%Y-%m-%dT%H:%M:%SZ")
      feed.author do |author|
        author.name blog_post.author
      end
    end
  end
end