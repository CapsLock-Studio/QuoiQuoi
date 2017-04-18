class CourseOptionGroup < ApplicationRecord
  default_scope ->() {order(:id)}

  validates :name, presence: true

  belongs_to :course
  belongs_to :locale

  has_many :course_options, dependent: :destroy
end
