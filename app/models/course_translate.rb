class CourseTranslate < ApplicationRecord
  belongs_to :course
  belongs_to :locale

  default_scope -> { order(:locale_id) }

  def description
    read_attribute(:description).gsub('target=""', 'target="_blank"')
                                .gsub('<img', '<img class="img-responsive"')
  end
end
