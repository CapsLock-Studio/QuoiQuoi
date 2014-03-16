class Order < ActiveRecord::Base
  belongs_to :user
  has_one :ship
  has_many :goods
end
