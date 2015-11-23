class UserController < ApplicationController
  before_action :authenticate_user!, except: [:email_signin, :email_authencate]

  def index
    render json: params[:id]
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

  def email_signin
    user = User.find_by_token(params[:token])
    if user.nil?
      render json: 'Token error!'
    else
      if Time.now > user.token_expire
        render json: 'Token expired!'
      else
        user.token = nil
        user.token_expire = nil
        user.save!

        if user.redirect_url.nil?
          sign_in_and_redirect(user)
        else
          sign_in(user)

          # Same code in application_controller.db - line 47
          # Order items in cart change it's owner.
          if session[:guest_user_id] && @order_in_cart
            @order_in_cart.user_id = user.id
            @order_in_cart.save

            User.find(session[:guest_user_id]).destroy
            session.delete(:guest_user_id)
          end

          redirect_to user.redirect_url
        end
      end
    end
  end

  def email_authencate
    user = User.find_by_email(params[:email])
    if user.nil?
      user = User.create(email: params[:email])
    end

    UserMailer.signin_confirmation(
        user,
        params[:redirect_url]).deliver_later

    render json: {
      email: params[:email],
      redirect_url: params[:redirect_url]
    }
  end

  private
    def user_params
      params.require(:user).permit(:name, :phone, :address, :line)
    end

    def password_params
      params.required(:user).permit(:password, :password_confirmation, :current_password)
    end
end