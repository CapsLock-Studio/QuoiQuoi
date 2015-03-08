class RegistrationOption < ActiveRecord::Base
  belongs_to :registration
  belongs_to :course_option
end
