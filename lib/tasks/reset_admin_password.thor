class Admin < Thor
  desc 'reset_password', 'reset admin password' 
  def reset_password
    require './config/environment'  
    User.find_by_login('admin').update_attributes!(:password => 'password', :password_confirmation => 'password')
  end
end
