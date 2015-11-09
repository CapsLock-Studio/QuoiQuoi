namespace :course do
  desc 'actions for course'
  task remind_before_one_day: :environment do
    Course.where('time >= ? AND time < ? AND canceled = ?', Date.tomorrow.beginning_of_day, Date.tomorrow.end_of_day, false)
          .includes(:registrations).each do |course|
            course.registrations.each do |registration|
              if !registration.registration_payment.cancel? && registration.registration_payment.completed?
                RegistrationMailer.remind_before_course_start(registration.id).deliver_now
              end
            end
    end
  end
end