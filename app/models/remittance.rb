class Remittance < ApplicationRecord
  has_many :remittance_translates, dependent: :destroy
  accepts_nested_attributes_for :remittance_translates
end
