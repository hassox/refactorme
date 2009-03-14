class ActivationsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  
  def new
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @user.active?
  rescue Exception => e
    redirect_to root_url
  end
 
  def create
    @user = User.find_by_login!(params[:id])

    raise Exception if @user.active?

    if @user.update_attributes(params[:user]) && @user.activate!
      @user.deliver_activation_confirmation!
      flash[:success] = "Your account has been activated."
      redirect_to account_url
    else
      render :action => 'new'
    end
  rescue Exception => e
      redirect_to root_url
  end

end