class UserGiftMailer < ActionMailer::Base
  default from: 'admin@quoiquoi.tw'

  def remind_to_pay(id, subject)
    @user_gift = UserGift.find(id)
    @locale_id = @user_gift.locale_id

    I18n.locale = @user_gift.locale.lang

    # Setup expire payment clean job
    CleanExpirePaymentsJob.set(
        wait_until: (@user_gift.user_gift_payment.expire_time.nil?)? (Time.now + 3.days).end_of_day : @user_gift.user_gift_payment.expire_time
    ).perform_later(@user_gift.user_gift_payment, t('payment_expired'))

    mail(to: @user_gift.user.email, bcc: ['quoiquoi.tw@gmail.com'], subject: subject)
  end

  def request_remit_payment_again(id)
    @report = UserGiftRemittanceReport.find(id)
    @user_gift = @report.user_gift_payment.user_gift
    @locale_id = @user_gift.locale_id

    I18n.locale = @user_gift.locale.lang

    mail(to: @user_gift.user.email, bcc: ['quoiquoi.tw@gmail.com'], subject: t('mailer.subject.payment.remittance_report_fail'))
  end

  def completed_confirmation(id)
    @user_gift = Order.find(id)
    @locale_id = @user_gift.locale_id

    I18n.locale = @user_gift.locale.lang

    mail(to: @user_gift.user.email, bcc: ['quoiquoi.tw@gmail.com'], subject: t('mailer.subject_for_completed_gift'))

    OrderMailer.remind_completed(@user_gift.id).deliver_later
  end

  # Send to manager for notification
  def remind_remittance_report(id)
    @report = UserGiftRemittanceReport.find(id)
    @user_gift = @report.user_gift_payment.user_gift
    mail(to: $redis.get('about:locale:1:email'), subject: "[quoiquoi.tw] 系統提醒 禮券購買編號#{@user_gift.id}有匯款回報 - 回報編號#{@report.id}待確認")
  end

  def send_to_other(user_gift_serial_id, email)
    @user_gift_serial = UserGiftSerial.find(user_gift_serial_id)
    @user_gift = @user_gift_serial.user_gift
    I18n.locale = Locale.find(@user_gift.locale_id).lang

    mail(to: email, subject: t('mailer.subject_for_send_gift_card'))
  end

  def used_remind(user_gift_serial_id)
    @user_gift_serial = UserGiftSerial.find(user_gift_serial_id)
    @user_gift = @user_gift_serial.user_gift
    I18n.locale = Locale.find(@user_gift.locale_id).lang

    mail(to: @user_gift.user.email, subject: t('mailer.subject_for_used_gift_card'))
  end
end
