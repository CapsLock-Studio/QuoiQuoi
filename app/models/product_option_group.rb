class ProductOptionGroup < ActiveRecord::Base
  validates :name, presence: true

  belongs_to :product
  belongs_to :locale

  has_many :product_options, dependent: :destroy
end
