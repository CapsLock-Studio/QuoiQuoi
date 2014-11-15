class PastWorkTranslate < ActiveRecord::Base
  default_scope -> { order(:locale_id) }
  belongs_to :locale
  belongs_to :past_work

  def description
    read_attribute(:description).gsub('target=""', 'target="_blank"')
                                .gsub('<img', '<img class="img-responsive"')
  end
end
