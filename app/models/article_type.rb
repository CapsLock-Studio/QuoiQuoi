class ArticleType < ApplicationRecord
  has_many :articles, dependent: :destroy
  belongs_to :locale
end
