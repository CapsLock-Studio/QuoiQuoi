class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :custom_order
end
