class CourseOptionGroup < ActiveRecord::Base
  validates :name, presence: true

  belongs_to :course
  belongs_to :locale

  has_many :course_options, dependent: :destroy
end
