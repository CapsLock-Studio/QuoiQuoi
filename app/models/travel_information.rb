class TravelInformation < ActiveRecord::Base
  belongs_to :area
  has_many :travel_photos, dependent: :destroy
end
