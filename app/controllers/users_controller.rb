class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
    redirect_to account_edit_path
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to account_path
      return
    else
      render 'edit'
    end
  end
  
  def password
    @user = current_user
  end
  
  def subscription
  end
  
end
