class CourseMailer < ApplicationMailer
  def self.cancel_notification(id)
    @course = Course.find(id)

    translates = {}
    @course.course_translates.each do |translate|
      translates[translate.locale.id] = {
          locale: translate.locale.lang,
          name: translate.name
      }
    end
    # mail(to: @course.registrations.pluck(:email), subject: t('mailer.subject.cancel_course'))
    @course.registrations.each do |registration|
      cancel_notification_individual(
          registration.email,
          registration.id,
          translates[registration.locale_id][:name],
          registration.locale_id,
          translates[registration.locale_id][:locale],
          registration.registration_payment.completed.to_s
      ).deliver_later
    end
  end

  def cancel_notification_individual(email, registration_id, course_name, locale_id, locale, is_completed)
    I18n.locale = locale
    @course_name = course_name
    @locale_id = locale_id
    @registration_id = registration_id
    @is_completed = is_completed

    mail(to: email, bcc: ['quoiquoi.tw@gmail.com'], subject: t('mailer.subject.cancel_course'))
  end
end
