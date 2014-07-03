class CourseOption < ActiveRecord::Base
  belongs_to :course
  belongs_to :locale
end
