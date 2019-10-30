class SubscriptionsController < ApplicationController
  resource_controller

  def index
    redirect_to :root; return
  end

  def show
    redirect_to :root; return
  end

  create do
    wants.html do
      flash[:notice] = nil
      flash[:success] = "Thank you for subscribing to our newsletter. You will receive emails to #{@subscription.email}" 
      Notifier.subscription(@object).deliver # sends the email
      redirect_to :root
    end
  end

end
