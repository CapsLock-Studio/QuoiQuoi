class RentInfo < ActiveRecord::Base
  has_many :rent_info_translates, dependent: :destroy
  accepts_nested_attributes_for :rent_info_translates, allow_destroy: true
end
