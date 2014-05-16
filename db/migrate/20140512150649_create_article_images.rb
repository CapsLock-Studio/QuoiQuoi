class CreateArticleImages < ActiveRecord::Migration
  def change
    create_table :article_images do |t|
      t.attachment :image

      t.timestamps
    end
  end
end
