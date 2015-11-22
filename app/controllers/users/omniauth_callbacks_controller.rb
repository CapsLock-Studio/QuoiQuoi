class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # when user give app authentication omni will call back
  # or it will return to sign in page and show flash message
  def google_oauth2
    user_sign_in('google_oauth2')
  end

  def facebook
    user_sign_in('facebook')
  end

  #def twitter
  #  @user = User.find_or_create_by_twitter(request.env['omniauth.auth'])
  #
  #  if @user.email
  #    redirect_to
  #  else
  #    sign_in_and_redirect @user, event: :authentication
  #  end
  #end

  private
  def user_sign_in(provider)
    @user = User.find_or_create_by_oauth2(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    end
  end
end
