set :application, 'hyc.ie'
load '/home/shared/capistrano/common.rb'
set :repository,  "git@git.isobar.ie:lucidity/hyc.ie.git"
set :branch, fetch(:branch, "master")
set :use_sudo, false

after 'deploy:update_code', :roles => [:web, :app] do
  run_locally "rm -rf public/assets; bundle exec rake assets:precompile RAILS_ENV=assets RAILS_GROUPS=assets STAGE=#{stage}"
  run_locally "tar cfz /tmp/assets-#{release_name}.tar.gz public/assets/"
  upload "/tmp/assets-#{release_name}.tar.gz", "/tmp/assets-#{release_name}.tar.gz", :via => :scp
  run_locally "rm -rf public/assets /tmp/assets-#{release_name}.tar.gz"
  run "cd #{release_path}; " +
      "tar xfz /tmp/assets-#{release_name}.tar.gz; " +
      "rm -f /tmp/assets-#{release_name}.tar.gz; " +
      "rm -Rf #{release_path}/public/system; " +
      "mkdir -p #{release_path}/../../shared/system; " +
      "ln -s #{release_path}/../../shared/system #{release_path}/public/system; " +
      "chmod 777 #{release_path}/../../shared/system; " +
      "chmod 777 #{release_path}/tmp/* #{release_path}/public; " +
      "cmp --quiet #{release_path}/Gemfile.lock #{release_path}/../../current/Gemfile.lock || (source /usr/local/rvm/scripts/rvm && echo Running bundle install && bundle install --quiet)"
end
