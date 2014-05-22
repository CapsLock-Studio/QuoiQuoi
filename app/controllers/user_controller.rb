class UserController < ApplicationController
  before_action :authenticate_user!

  def index

  end

  def edit

  end

  def update
    respond_to do |format|
      if current_user.update_attributes(user_params)
        format.html {redirect_to action: :index}
      else
        format.html {render action: :edit}
      end
    end
  end

  def password
    @user = current_user
    if current_user.provider
      render json: ''
    end
  end

  def update_password
    @user = User.find(current_user.id)
    if current_user.provider
      render json: ''
    else
      if @user.update_with_password(password_params)
        # Sign in the user by passing validation in case his password changed
        sign_in @user, :bypass => true
        redirect_to user_path
      else
        render :password
      end
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :phone, :address, :line)
    end

    def password_params
      params.required(:user).permit(:password, :password_confirmation, :current_password)
    end
end