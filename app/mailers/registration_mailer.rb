class RegistrationMailer < ApplicationMailer
  def remind_to_pay(id, subject)
    @registration = Registration.includes(:course).find(id)
    @locale_id = @registration.locale_id

    I18n.locale = @registration.locale.lang

    # Setup expire payment clean job
    CleanExpirePaymentsJob.set(
        wait_until: (@registration.registration_payment.expire_time.nil?)? (Time.now + 3.days).end_of_day : @registration.registration_payment.expire_time
    ).perform_later(@registration.registration_payment, t('payment_expired'))

    mail(to: @registration.email, subject: subject)
  end

  def request_remit_payment_again(id)
    @report = RegistrationRemittanceReport.find(id)
    @registration = @report.registration_payment.registration
    @locale_id = @registration.locale_id

    I18n.locale = @registration.locale.lang

    mail(to: @registration.email, subject: t('mailer.subject.payment.remittance_report_fail'))
  end

  def completed_confirmation(id)
    @registration = Registration.includes(:course).find(id)
    @locale_id = @registration.locale_id

    I18n.locale = @registration.locale.lang

    mail(to: @registration.email, subject: t('mailer.subject.registration'))
  end

  def remind_before_course_start(id)
    @registration = Registration.includes(:course).find(id)
    @locale_id = @registration.locale_id

    I18n.locale = @registration.locale.lang

    mail(to: @registration.email, subject: t('mailer.subject.remind_before_course_start'))
  end

  def cancel_notification(id)
    registration = Registration.find(id)
    @registration_id = registration.id
    @locale_id = registration.locale_id
    @cancel_reason = registration.registration_payment.cancel_reason
    @is_completed = registration.registration_payment.completed.to_s
    @course_name = registration.course.course_translates.find_by_locale_id(@locale_id).name
    I18n.locale = registration.locale.lang

    mail(to: registration.email, from: $redis.get('about:locale:1:email'), subject: t('mailer.subject.cancel_registration'))
  end

  def remind_remittance_report(id)
    @report = RegistrationRemittanceReport.find(id)
    @registration = @report.registration_payment.registration
    mail(to: $redis.get('about:locale:1:email'), subject: "[quoiquoi.tw] 系統提醒 報名編號#{@registration.id}有匯款回報 - 回報編號#{@report.id}待確認")
  end
end