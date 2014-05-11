class ArticleType < ActiveRecord::Base
  has_many :article_type_translates, dependent: :destroy
  accepts_nested_attributes_for :article_type_translates, allow_destroy: true

  has_many :articles, dependent: :destroy
end
