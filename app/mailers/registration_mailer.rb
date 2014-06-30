class RegistrationMailer < ActionMailer::Base
  default from: 'admin@quoiquoi.tw'

  def remittance_remind(registration, locale_id, domain)
    @registration = registration
    @locale_id = locale_id
    @domain = domain
    mail(to: (registration.user)? registration.user.email : registration.email, subject: t('mailer.subject_for_remittance_registration'))
  end

  def remind(registration, locale_id, domain)
    @registration = registration
    @locale_id = locale_id
    @domain = domain
    mail(to: (registration.user)? registration.user.email : registration.email, subject: t('mailer.subject_for_registration'))
  end

  def cancel_remind(registration, locale_id, domain)
    @registration = registration
    @locale_id = locale_id
    @domain = domain
    mail(to: (registration.user)? registration.user.email : registration.email, subject: "#{t('mailer.subject_for_cancel_registration')} #{t('mailer.help_return_tuition') if registration.payment && registration.payment.completed?}")
  end
end