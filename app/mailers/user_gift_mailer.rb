class UserGiftMailer < ActionMailer::Base
  include Resque::Mailer
  default from: 'admin@quoiquoi.tw'

  def remittance_remind(user_gift_id)
    @user_gift = UserGift.find(user_gift_id)
    I18n.locale = Locale.find(@user_gift.locale_id).lang

    mail(to: @user_gift.user.email, subject: t('mailer.subject_for_remittance_gift'))
  end

  def remittance_remind_three_days(user_gift_id)
    @user_gift = UserGift.find(user_gift_id)
    I18n.locale = Locale.find(@user_gift.locale_id).lang

    mail(to: @user_gift.user.email, subject: t('mailer.subject_for_three_days'))
  end

  def re_remittance_remind(user_gift_id)
    @user_gift = UserGift.find(user_gift_id)
    I18n.locale = Locale.find(@user_gift.locale_id).lang

    mail(to: @user_gift.user.email, subject: t('mailer.subject_for_re_remittance'))
  end

  def completed_remind(user_gift_id)
    @user_gift = UserGift.find(user_gift_id)
    @locale_lang = Locale.find(@user_gift.locale_id).lang
    I18n.locale = @locale_lang

    mail(to: @user_gift.user.email, subject: t('mailer.subject_for_completed_gift'))
  end

  def send_to_other(user_gift_serial_id, email)
    @user_gift_serial = UserGiftSerial.find(user_gift_serial_id)
    @user_gift = @user_gift_serial.user_gift
    I18n.locale = Locale.find(@user_gift.locale_id).lang

    mail(to: email, subject: t('mailer.subject_for_send_gift_card'))
  end
end
