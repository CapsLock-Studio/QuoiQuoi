# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def signin_confirmation
    UserMailer.signin_confirmation(User.find_by_email('ts01364362@gmail.com'), 'http://localhost:3000')
  end
end
