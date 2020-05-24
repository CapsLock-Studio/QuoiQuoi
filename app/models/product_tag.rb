class ProductTag < ApplicationRecord
  has_and_belongs_to_many :products

  has_one :product_tag_translate
  has_many :product_tag_translates, dependent: :destroy

  has_many :locales, through: :product_tag_translates

  accepts_nested_attributes_for :product_tag_translates, allow_destroy: true

  # thumbnail in type list page
  has_attached_file :thumbnail, styles: {medium: '300x225#'}, default_url: 'http://placehold.it/300x225'
  validates_attachment_content_type :thumbnail, content_type: /\Aimage\/.*\Z/

  # hero image in page header in list page
  has_attached_file :image, styles: {large: '960x260#'}, default_url: 'http://placehold.it/960x260'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
