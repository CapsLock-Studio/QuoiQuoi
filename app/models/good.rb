class Good < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  has_many :good_custom_items
  has_many :good_custom_description_images
end
