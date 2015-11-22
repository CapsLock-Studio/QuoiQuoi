class UserMailer < ApplicationMailer
  def signin_confirmation(user, redirect_url)
    user.token = Devise.friendly_token[0, 20]
    user.token_expire = Time.now + 15.minutes
    user.redirect_url = redirect_url
    user.save!

    @token = user.token
    mail(to: user.email, subject: t('mailer.text.user.sign_in'))
  end
end
