class RegistrationMailer < ActionMailer::Base
  default from: 'admin@quoiquoi.tw'

  def remittance_remind(registration, locale_id, domain)
    @registration = registration
    @locale_id = locale_id
    @domain = domain
    mail(to: (registration.user)? user.email : registration.email, subject: '[quoiquoi.tw] 課程匯款提醒通知信 (系統自動寄出請勿回覆)')
  end

  def remind(registration, locale_id, domain)
    @registration = registration
    @locale_id = locale_id
    @domain = domain
    mail(to: (registration.user)? user.email : registration.email, subject: '[quoiquoi.tw] 課程提醒通知信 (系統自動寄出請勿回覆)')
  end

  def cancel_remind(registration, locale_id, domain)
    @registration = registration
    @locale_id = locale_id
    @domain = domain
    mail(to: (registration.user)? user.email : registration.email, subject: "[quoiquoi.tw] 課程取消通知信 #{'(請協助回復退還報名金所需資料)' if registration.payment && registration.payment.completed?}")
  end
end