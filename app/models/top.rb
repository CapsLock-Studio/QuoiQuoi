class Top < ApplicationRecord
  has_many :top_translates, dependent: :destroy

  accepts_nested_attributes_for :top_translates
  has_attached_file :image, styles: {medium: '500x375#'}, default_url: '/system/placeholder/:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
