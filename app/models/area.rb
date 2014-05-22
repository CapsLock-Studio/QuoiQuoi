class Area < ActiveRecord::Base
  has_many :travel_informations
  belongs_to :locale
end
