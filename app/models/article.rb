class Article < ActiveRecord::Base
  belongs_to :article_type

  has_many :article_images, dependent: :destroy
  accepts_nested_attributes_for :article_images, allow_destroy: true
end
