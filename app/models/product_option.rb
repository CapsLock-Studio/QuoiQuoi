class ProductOption < ApplicationRecord
  default_scope ->() {order(:id)}

  validates :price, numericality: true, presence: true
  validates :content, presence: true, allow_blank: false

  belongs_to :product
  belongs_to :locale

  belongs_to :product_option_group
end
