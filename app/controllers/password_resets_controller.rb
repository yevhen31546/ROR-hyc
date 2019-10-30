# taken from http://github.com/binarylogic/authlogic_example
# http://www.binarylogic.com/2008/11/16/tutorial-reset-passwords-with-authlogic/

class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user
  
  def new
  end

  def edit
  end
 
  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.reset_perishable_token!  
      Notifier.default_url_options[:host] = request.host_with_port
      Notifier.password_reset_instructions(@user).deliver
      flash[:notice] = 'Instructions to reset your password have been emailed to you. Please check your email.'
      redirect_to :root; return
    else
      flash[:error] = 'No user was found with that email address'
      redirect_to forgot_password_url; return
    end
  end
  
  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if !@user.password.blank? && @user.save
      flash[:success] = 'Password successfully updated'
      redirect_to account_path; return
    else
      render :action => :edit; return
    end
  end
 
  private
    def load_user_using_perishable_token
      @user = User.find_using_perishable_token(params[:id])
      unless @user
        flash[:error] = "We're sorry, but we could not locate your account. If you are having issues try copying and pasting the URL from your email into your browser or restarting the reset password process."
        redirect_to :root; return
      end
    end
end
