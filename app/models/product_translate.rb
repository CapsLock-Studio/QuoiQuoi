class ProductTranslate < ApplicationRecord
  default_scope -> { order(:locale_id) }

  belongs_to :product
  belongs_to :locale

  def description
    read_attribute(:description).gsub('target=""', 'target="_blank"')
                                .gsub('<img', '<img class="img-responsive"')
  end
end
