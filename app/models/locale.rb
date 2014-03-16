class Locale < ActiveRecord::Base
  validates :lang, presence: true
  validates :name, presence: true

  has_many :product_translates
  accepts_nested_attributes_for :product_translates, allow_destroy: true
  has_many :product_custom_item_translates
  has_many :product_custom_type_translates
end