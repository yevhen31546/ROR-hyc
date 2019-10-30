def truncate_table(model)
  model.connection.execute("TRUNCATE #{model.table_name}")
end

truncate_table(User)
admin_password = 'password'
admin = Role.create(:name => "admin")
superadmin = Role.create(:name => "superadmin")
User.create!(:login => 'admin', :email => 'shai@lucidity.ie', :password => admin_password,
             :password_confirmation => admin_password, :role_id => admin.id)

# create super user - it is expected that the super user need only be used by the developers of the site
super_admin_password = 'quagCob4'
User.create!(:login => 'superadmin', :email => 'info@lucidity.ie', :password => super_admin_password,
             :password_confirmation => super_admin_password, :role => superadmin)


robots_txt = "# See http://www.robotstxt.org/wc/norobots.html for documentation on how to use the robots.txt file\n#\n# To ban all spiders from the entire site uncomment the next two lines:\n# User-Agent: *\n# Disallow: /"

truncate_table(Setting)
[
    {:key => 'site_name', :value => 'Example.com', :label => 'Site Name', :value_type => 'string'},
    {:key => 'site_description', :value => '', :label => 'Site Description', :value_type => 'text'},
    {:key => 'site_keywords', :value => '', :label => 'Site Keywords', :value_type => 'string'},
    {:key => 'contact_number', :value => '+353 1 xxx xxxx', :label => 'Contact Number', :value_type => 'string'},
    {:key => 'contact_mobile', :value => '', :label => 'Contact Number (Mobile)', :value_type => 'string'},
    {:key => 'contact_fax', :value => '', :label => 'Contact Fax', :value_type => 'string'},
    {:key => 'contact_email', :value => 'info@example.com', :label => 'Contact Email', :value_type => 'string'},
    {:key => 'contact_address_org', :value => 'Lucidity Digital', :label => 'Organisation Name', :value_type => 'string'},
    {:key => 'contact_street_address', :value => 'Example address 1', :label => 'Street Address', :value_type => 'text'},
    {:key => 'contact_extended_address', :value => 'Example address 2', :label => 'Extended Address', :value_type => 'text'},
    {:key => 'contact_locality', :value => 'Dublin', :label => 'Locality', :value_type => 'string'},
    {:key => 'contact_region', :value => 'Co. Dublin', :label => 'Region', :value_type => 'string'},
    {:key => 'contact_country_name', :value => 'Ireland', :label => 'Country', :value_type => 'string'},
    {:key => 'contact_latitude', :value => '53.344089', :label => 'Map Latitude', :value_type => 'string'},
    {:key => 'contact_longitude', :value => '-6.267421', :label => 'Map Longitude', :value_type => 'string'},
    {:key => 'system_email', :value => 'Example.com <system@example.com>', :label => 'System Email', :value_type => 'string'},
    {:key => 'google_analytics_id', :value => 'UA-XXXXX-X', :label => 'Google Analytics ID', :value_type => 'string'},
    {:key => 'twitter_username', :value => 'luciditydigital', :label => 'Twitter Username', :value_type => 'string'},
    {:key => 'google_site_verification', :value => 'googlexxxxxxxxxxxxxxxx', :label => 'Google Site Verification', :value_type => 'string'},
    {:key => 'robots', :value => robots_txt, :label => 'robots.txt', :value_type => 'text'}
].each do |mod_attrs|
  Setting.create!(mod_attrs)
end


truncate_table(AdminModule)
[
    {:sort => '10', :name => 'Pages', :controller => 'pages', :active => true},
    {:sort => '20', :name => 'Images', :controller => 'images', :active => true},
    {:sort => '30', :name => 'Resources', :controller => 'resources', :active => true},
    {:sort => '40', :name => 'News', :controller => 'news_items', :active => true},
    {:sort => '50', :name => 'Blog', :controller => 'blog_posts', :active => true},
    {:sort => '60', :name => 'Gallery', :controller => 'gallery_albums', :active => true},
    {:sort => '70', :name => 'Videos', :controller => 'videos', :active => true},
    {:sort => '80', :name => 'Events', :controller => 'events', :active => true},
    {:sort => '90', :name => 'Testimonials', :controller => 'testimonials', :active => true},
    {:sort => '100', :name => 'Team', :controller => 'team_members', :active => true},
    {:sort => '110', :name => 'Subscriptions', :controller => 'subscriptions', :active => true},
    {:sort => '140', :name => 'Enquiries', :controller => 'enquiries', :active => true},
    {:sort => '950', :name => 'Navigation', :controller => 'navbars', :active => true},
    {:sort => '960', :name => 'Users', :controller => 'users', :active => true},
    {:sort => '990', :name => 'Modules', :controller => 'admin_modules', :active => false},
    {:sort => '1000', :name => 'Settings', :controller => 'settings', :active => true},
    {:sort => '1050', :name => 'Entry Forms', :controller => 'entry_forms', :active => true},
].each do |mod_attrs|
  AdminModule.create!(mod_attrs)
end

lorem_ipsum_short = "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc posuere quam a felis feugiat sit amet rhoncus mi scelerisque. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla in arcu odio.</p>"
lorem_ipsum_long = "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc posuere quam a felis feugiat sit amet rhoncus mi scelerisque. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla in arcu odio. Duis vitae ligula a nisi imperdiet suscipit. Integer blandit dui et sem euismod pretium sagittis massa pellentesque. Morbi lacinia aliquam tempor. Curabitur aliquam arcu et ante sodales pretium. Duis sagittis ornare nisl id euismod. In dapibus pretium est, sit amet porttitor mi malesuada eget. Cras rutrum justo quis arcu porta id aliquet est ullamcorper. Aenean eu est in felis suscipit iaculis sed et tellus. Etiam aliquam blandit justo sed mollis.</p>\n<p>Phasellus eget lobortis nulla. Cras commodo ullamcorper sapien et tincidunt. Quisque venenatis nisi ut elit consequat quis elementum eros molestie. Nullam sodales, urna ut interdum volutpat, augue sapien egestas arcu, eget ornare sem metus nec odio. Etiam mi diam, laoreet vitae placerat a, scelerisque consectetur nibh. Proin eget tortor non dui mollis consectetur a non ipsum. Sed fermentum nisi in lacus pulvinar semper. Aliquam ornare elementum erat, eu aliquam lorem volutpat vel. Duis eros sem, vestibulum in volutpat a, faucibus at risus. Fusce dignissim faucibus diam, quis adipiscing magna adipiscing ut. Aliquam tempus, lacus nec dictum ullamcorper, orci libero lacinia ipsum, nec consectetur leo libero vitae lectus. Fusce scelerisque interdum dolor, non egestas orci mattis vitae. Donec euismod, justo suscipit tempus fringilla, neque orci ullamcorper sapien, vitae vestibulum elit elit a quam. Duis pulvinar, ante eget vehicula tincidunt, dolor orci tristique ipsum, id malesuada mi diam sed velit. Vivamus varius bibendum tortor, a tristique arcu rutrum vestibulum. Pellentesque elementum, felis eu placerat tristique, lorem ipsum aliquam lorem, et dapibus urna quam sed felis. Mauris et mi et sem facilisis bibendum eget sit amet purus. Vestibulum blandit accumsan sem, non ullamcorper nulla bibendum ac. Ut sed sapien felis, et tristique sem. Donec in laoreet enim.</p>"

truncate_table(Page)
[
    {:code => 'homepage', :title => 'Homepage', :extended_title => 'Welcome', :url => '/', :content => lorem_ipsum_long},
    {:code => 'about', :title => 'About Us', :url => '/about', :content => lorem_ipsum_long},
    {:code => 'contact', :title => 'Contact Us', :url => '/contact', :content => ''},
    {:code => 'welcome-sidebar-content', :title => 'welcome sidebar content', :url => '/welcome-sidebar-content', :content => ''},
    {:code => 'join-our-club', :title => 'Join our club', :url => '/join-our-club', :content => ''}
].each do |mod_attrs|
  Page.create!(mod_attrs)
end

truncate_table(Navbar)
[
    {:code => 'main', :name => 'Main Navbar'}
].each do |mod_attrs|
  Navbar.create!(mod_attrs)
end

truncate_table(NavbarItem)
[
    {:navbar_id => Navbar.find_by_code('main').id, :position => 10, :name => 'Home', :controller => 'welcome'},
    {:navbar_id => Navbar.find_by_code('main').id, :position => 20, :name => 'About', :page_id => Page.find_by_code('about').id},
    {:navbar_id => Navbar.find_by_code('main').id, :position => 500, :name => 'News', :controller => 'news_items'},
    {:navbar_id => Navbar.find_by_code('main').id, :position => 510, :name => 'Events', :controller => 'events'},
    {:navbar_id => Navbar.find_by_code('main').id, :position => 520, :name => 'Blog', :controller => 'blog_posts'},
    {:navbar_id => Navbar.find_by_code('main').id, :position => 530, :name => 'Testimonials', :controller => 'testimonials'},
    {:navbar_id => Navbar.find_by_code('main').id, :position => 530, :name => 'Team', :controller => 'team_members'},
    {:navbar_id => Navbar.find_by_code('main').id, :position => 540, :name => 'Gallery', :controller => 'gallery_albums'},
    {:navbar_id => Navbar.find_by_code('main').id, :position => 540, :name => 'Videos', :controller => 'videos'},
    {:navbar_id => Navbar.find_by_code('main').id, :position => 990, :name => 'Contact', :controller => 'contact_us'}
].each do |mod_attrs|
  NavbarItem.create!(mod_attrs)
end

truncate_table(Testimonial)
[
    {:name => 'John Doe', :from => 'Acme Inc.', :quote => lorem_ipsum_long.gsub(/<\/?p>/, '')},
    {:name => 'Joe Bloggs', :from => 'Dublin', :quote => lorem_ipsum_long.gsub(/<\/?p>/, '')}
].each do |mod_attrs|
  Testimonial.create!(mod_attrs)
end

truncate_table(TeamMember)
[
    {:name => 'John Doe', :role => 'CEO', :content => lorem_ipsum_short, :sort => 10},
    {:name => 'Joe Bloggs', :role => 'Manager', :content => lorem_ipsum_short, :sort => 20}
].each do |mod_attrs|
  TeamMember.create!(mod_attrs)
end

truncate_table(BlogPost)
[
    {:title => 'My first blog post', :content => lorem_ipsum_long, :author => 'Joe Bloggs'},
    {:title => 'Another blog post', :content => lorem_ipsum_long},
    {:title => 'Yet another blog post', :content => lorem_ipsum_long, :author => 'John Doe'}
].each do |mod_attrs|
  BlogPost.create!(mod_attrs)
end

truncate_table(NewsItem)
[
    {:title => 'My first news', :content => lorem_ipsum_long},
    {:title => 'Another news item', :content => lorem_ipsum_long},
    {:title => 'Yet another news item', :content => lorem_ipsum_long}
].each do |mod_attrs|
  NewsItem.create!(mod_attrs)
end

truncate_table(Video)
[
    {:title => 'Lucidity Showreel', :url => 'http://www.youtube.com/watch?v=6bYM87UdXx0'},
].each do |mod_attrs|
  Video.create!(mod_attrs)
end

truncate_table(Event)
[
    {:title => 'My first event', :summary => lorem_ipsum_long, :event_type => 'social', :date => 0.days.from_now},
    {:title => 'Another event', :summary => lorem_ipsum_long, :event_type => 'social', :date => 40.days.from_now},
    {:title => 'Yet another event', :summary => lorem_ipsum_long, :event_type => 'social', :date => 80.days.from_now}
].each do |mod_attrs|
  Event.create!(mod_attrs)
end

truncate_table(Subscription)
