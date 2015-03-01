class CourseOption < ActiveRecord::Base
  validates :price, numericality: true, presence: true
  validates :content, presence: true, allow_blank: false

  belongs_to :course
  belongs_to :locale

  belongs_to :course_option_group
end
