class AddArticleReferenceToArticleImages < ActiveRecord::Migration
  def change
    add_reference :article_images, :article, index: true
  end
end
