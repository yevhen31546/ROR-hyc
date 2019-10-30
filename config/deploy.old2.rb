# config valid only for current version of Capistrano

set :application, "hyc-site"
set :repo_url, "git@bitbucket.org:vinylmattmedia/#{fetch(:application)}.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/#{fetch(:application)}"
set :migration_role, :app
## Capistrano-passenger restart configuration
# we need to set rvm to use the version of ruby that passenger is installed with
set :passenger_rvm_ruby_version, "ruby-2.3.3"

# by default capistrano-passenger tries to run the command with the option '--ignore-app-not-running'
# but this is not supported by all versions of passenger
# set :passenger_restart_options, -> { "#{deploy_to}" }

# this user needs to be able to run rvmsudo without a password for this to work
# set :passenger_restart_with_sudo, true

# if your deploy user can't run `rvmsudo passenger-config restart-app /path/to/app`
# then you can fallback to restarting with touch
# set :passenger_restart_with_touch, true

set :rvm_ruby_version, '2.3.3'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_files, 'config/database.yml'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# RAILS_GROUPS env value for the assets:precompile task. Default to nil.
set :rails_assets_groups, :assets