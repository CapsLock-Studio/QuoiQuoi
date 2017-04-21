class RegistrationOption < ApplicationRecord
  belongs_to :registration
  belongs_to :course_option
end
