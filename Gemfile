# Git test
source "http://rubygems.org"
ruby '2.3.0'

gem "rails", "3.2.22.4"
gem "mysql2", "~> 0.3.21"
gem 'json', '~> 1.8.3'
gem "jquery-rails", "~> 3.1.3"
gem "paperclip", "~> 2.7.0"
gem "parndt-acts_as_tree", "~> 1.2.5", :require => "acts_as_tree"
gem "authlogic", "~> 3.1.0"
gem "formtastic", "~> 1.2.4"
gem "haml", "~> 4.0.7"
gem "haml-contrib", "~> 1.0.0.1" # required for textile filter

gem "truncate_html", "~> 0.9.3" # I've been using this one since the start but it drops unicode chars like euro symbol
gem "html_truncator", "~> 0.4.1" # this one does not drop unicode characters
gem "RedCloth", "= 4.2.9"
gem "makandra_resource_controller", "~> 0.7.3", :git => 'https://github.com/vlmonk/resource_controller.git' # rails 3.2 branch
gem "kaminari", "~> 0.13.0"
gem "nokogiri", "~> 1.5.6", :require => false  # will not be required unless used
gem "bcrypt-ruby", "~> 3.0.1"
gem "default_value_for", "~> 3.0.0"
# gem "plupload-rails"
gem 'plupload-rails', '~> 1.2', '>= 1.2.1'

gem "active_utils", '~> 2.2.1'

gem "activemerchant", '1.34.1'

# vendorizing this gem in order make modifications to it - use `git log vendor/gems` to see the changes
gem 'activemerchant-realex3ds', '~> 1.0.1', :path => "vendor/gems/activemerchant-realex3ds-1.0.1"
# gem "forem", '1.0.0.beta1', :git => "https://github.com/radar/forem.git"
gem 'airbrake', "~> 3.1.8"
gem "rinku", "~> 1.7.3", :require => "rails_rinku"

gem 'sitemap_generator', '~> 5.1.0'
#gem "rails_admin", :git => "git://github.com/sferik/rails_admin.git"

# encryption for realex 3d secure payments
gem 'encryptor', '~> 1.3.0'

group :production do
  gem "puma"
end

group :development do
  # gem "rails-dev-boost", :git => "git://github.com/thedarkone/rails-dev-boost.git", :require => "rails_development_boost"
  # gem "rails-dev-tweaks", "~> 0.5.1"
  # gem 'ruby-debug19'
  gem "quiet_assets", "~> 1.0.1"
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false

  # gem 'better_errors', "~> 0.5.0"
  # gem 'binding_of_caller'
 # 'test-unit', '~> 3.0'
end
gem 'test-unit', '~> 3.0'
gem 'httparty'
group :assets do

  gem "sass-rails", "= 3.2.6"
  gem "coffee-rails", "= 3.2.1"

  gem "uglifier", "~> 1.2.2"
  gem "therubyracer", "~> 0.12.1"  # For CoffeeScript
  gem 'jquery-ui-rails', "~> 3.0.0"
end
