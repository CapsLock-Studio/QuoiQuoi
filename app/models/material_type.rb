class MaterialType < ApplicationRecord
  has_many :materials

  has_one :material_type_translate
  has_many :material_type_translates

  has_many :product_material_types

  accepts_nested_attributes_for :material_type_translates, allow_destroy: true
end
