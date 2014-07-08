class RegistrationMailer < ActionMailer::Base
  default from: 'admin@quoiquoi.tw'

  def remittance_remind(registration, domain)
    I18n.locale = Locale.find(registration.locale_id).lang

    @registration = registration
    @domain = domain
    mail(to: (registration.user)? registration.user.email : registration.email, subject: t('mailer.subject_for_remittance_registration'))
  end

  def remittance_remind_three_days(registration)
    I18n.locale = Locale.find(registration.locale_id).lang

    @registration = registration
    mail(to: (registration.user)? registration.user.email : registration.email, subject: t('mailer.subject_for_remittance_registration'))
  end

  def remind(registration, domain)
    I18n.locale = Locale.find(registration.locale_id).lang

    @registration = registration
    @domain = domain
    mail(to: (registration.user)? registration.user.email : registration.email, subject: t('mailer.subject_for_registration'))
  end

  def re_remittance_remind(registration)
    I18n.locale = Locale.find(registration.locale_id).lang

    @registration = registration
    mail(to: (registration.user)? registration.user.email : registration.email, subject: t('mailer.subject_for_re_remittance'))
  end

  def cancel_remind(registration, locale_id, domain)
    I18n.locale = Locale.find(registration.locale_id).lang

    @registration = registration
    @locale_id = locale_id
    @domain = domain
    mail(to: (registration.user)? registration.user.email : registration.email, subject: "#{t('mailer.subject_for_cancel_registration')} #{t('mailer.help_return_tuition') if registration.payment && registration.payment.completed?}")
  end
end