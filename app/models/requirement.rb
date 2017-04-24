class Requirement < ApplicationRecord
  has_many :requirement_translates, dependent: :destroy
  accepts_nested_attributes_for :requirement_translates, allow_destroy: true
end