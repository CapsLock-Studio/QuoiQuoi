class Area < ApplicationRecord
  has_many :travel_informations
  belongs_to :locale
end
