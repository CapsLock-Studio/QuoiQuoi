class CourseTranslate < ActiveRecord::Base
  belongs_to :course
  belongs_to :locale

  def description
    read_attribute(:description).gsub('target=""', 'target="_blank"')
  end
end
