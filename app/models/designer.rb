class Designer < ApplicationRecord
  has_many :designer_translates, dependent: :destroy
  accepts_nested_attributes_for :designer_translates, allow_destroy: true

  has_attached_file :avatar, styles: {thumb: '100x100#', medium: '200x200#', large: '500x500#'}, default_url: '/system/placeholder/avatar-:style.gif'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  has_attached_file :photo, styles: {thumb: '100x75#', medium: '500x375#', large: '1000x750#'}, default_url: '/system/placeholder/:style.gif'
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
end
