class ArticleTypeTranslate < ActiveRecord::Base
  belongs_to :article_type
  belongs_to :locale
end
