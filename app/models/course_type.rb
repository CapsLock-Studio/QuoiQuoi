class CourseType < ActiveRecord::Base
  has_many :course_type_translates
  has_many :locales, through: :course_type_translates

  has_many :courses
end
