class Broadcast < ApplicationRecord
  has_many :broadcast_translates

  accepts_nested_attributes_for :broadcast_translates, allow_destroy: true
end
