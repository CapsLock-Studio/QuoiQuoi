class MaterialType < ActiveRecord::Base
  has_many :materials
  has_many :material_type_translates

  accepts_nested_attributes_for :material_type_translates, allow_destroy: true
end
