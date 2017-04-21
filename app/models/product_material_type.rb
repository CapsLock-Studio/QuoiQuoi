class ProductMaterialType < ApplicationRecord
  belongs_to :product
  belongs_to :material_type

  accepts_nested_attributes_for :material_type
end
