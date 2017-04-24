class CourseOption < ApplicationRecord
  default_scope ->() {order(:id)}

  validates :price, numericality: true, presence: true
  validates :content, presence: true, allow_blank: false

  belongs_to :course
  belongs_to :locale

  belongs_to :course_option_group
end
