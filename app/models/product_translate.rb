class ProductTranslate < ActiveRecord::Base
  belongs_to :product
  belongs_to :locale

  def description
    read_attribute(:description).gsub('target=""', 'target="_blank"')
  end
end
