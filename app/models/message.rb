class Message < ApplicationRecord
  belongs_to :user
  belongs_to :custom_order
end
