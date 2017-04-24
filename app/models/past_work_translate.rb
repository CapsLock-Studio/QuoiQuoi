class PastWorkTranslate < ApplicationRecord
  default_scope -> { order(:locale_id) }
  belongs_to :locale
  belongs_to :past_work

  def description
    read_attribute(:description).gsub('target=""', 'target="_blank"')
  end
end
