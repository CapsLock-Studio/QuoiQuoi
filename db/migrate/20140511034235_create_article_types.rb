class CreateArticleTypes < ActiveRecord::Migration
  def change
    create_table :article_types do |t|

      t.timestamps
    end
  end
end
