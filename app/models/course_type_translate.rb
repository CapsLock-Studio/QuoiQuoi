class CourseTypeTranslate < ActiveRecord::Base
  belongs_to :locale
  belongs_to :course_type
end
