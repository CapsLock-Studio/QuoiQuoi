class ProductType < ActiveRecord::Base
  has_many :products

  has_one :product_type_translate
  has_many :product_type_translates, dependent: :destroy

  has_many :locales, through: :product_type_translates

  accepts_nested_attributes_for :product_type_translates, allow_destroy: true
end
