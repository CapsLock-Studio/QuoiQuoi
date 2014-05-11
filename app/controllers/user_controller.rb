class UserController < ApplicationController
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

  private
    def user_params
      params.require(:user).permit(:name, :phone, :address, :line)
    end
end