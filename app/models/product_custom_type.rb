class ProductCustomType < ActiveRecord::Base
  has_many :product_custom_type_translates, dependent: :destroy
  has_many :locales, through: :product_custom_type_translates
  accepts_nested_attributes_for :product_custom_type_translates, allow_destroy: true

  has_many :product_custom_items
end