class ArticleType < ActiveRecord::Base
  has_many :articles, dependent: :destroy
  belongs_to :locale
end
