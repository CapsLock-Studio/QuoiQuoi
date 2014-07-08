class UserGiftMailer < ActionMailer::Base
  default from: 'admin@quoiquoi.tw'

  def remittance_remind(user_gift)
    I18n.locale = Locale.find(user_gift.locale_id).lang

    @user_gift = user_gift
    mail(to: user_gift.user.email, subject: t('mailer.subject_for_remittance_gift'))
  end

  def remittance_remind_three_days(user_gift)
    I18n.locale = Locale.find(user_gift.locale_id).lang

    @user_gift = user_gift
    mail(to: user_gift.user.email, subject: t('mailer.subject_for_remittance_gift'))
  end

  def re_remittance_remind(user_gift)
    I18n.locale = Locale.find(user_gift.locale_id).lang

    @user_gift = user_gift
    mail(to: user_gift.user.email, subject: t('mailer.subject_for_re_remittance'))
  end

  def completed_remind(user_gift)
    @locale_lang = Locale.find(user_gift.locale_id).lang
    I18n.locale = @locale_lang

    @user_gift = user_gift
    mail(to: user_gift.user.email, subject: t('mailer.subject_for_completed_gift'))
  end
end
