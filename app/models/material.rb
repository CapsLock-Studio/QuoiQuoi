class Material < ActiveRecord::Base
  has_many :material_translates, dependent: :destroy
  belongs_to :material_type

  accepts_nested_attributes_for :material_translates, allow_destroy: true
  has_attached_file :image, styles: {thumb: '100x75#', medium: '500x375#', large: '1000x750#'}, default_url: '/system/placeholder/:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
