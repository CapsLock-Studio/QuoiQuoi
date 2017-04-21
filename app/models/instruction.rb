class Instruction < ApplicationRecord
  belongs_to :locale

  has_many :instruction_images, dependent: :destroy
  accepts_nested_attributes_for :instruction_images
end
