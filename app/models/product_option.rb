class ProductOption < ActiveRecord::Base
  validates :price, numericality: true, presence: true
  validates :content, presence: true, allow_blank: false

  belongs_to :product
  belongs_to :locale

  belongs_to :product_option_group
end
