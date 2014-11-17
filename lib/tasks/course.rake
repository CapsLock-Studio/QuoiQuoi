namespace :course do
  desc 'actions for course'
  task remind_before_one_day: :environment do
    #RegistrationMailer.remind_before_start(:id).deliver
    Course.where('time >= ? AND time < ?', Time.now + 1.days, Time.now + 2.days)
          .includes(:registrations)
          .where(registrations: {canceled: false}).each do |course|
            course.registrations.includes(:payment)
                                .each do |registration|
                                  if registration.payment && registration.payment.completed? && !registration.canceled?
                                    RegistrationMailer.remind_before_start(registration.id).deliver
                                  end
                                end
          end
  end
end