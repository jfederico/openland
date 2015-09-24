class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user
    else
      render 'new'
    end

  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
  end

  def edit
  end

  def destroy
  end

  def show
  end

  private
    def user_params
        params.require(:user).permit(:username, :email, :first_name, :last_name, :password)
    end

end