class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.references :article_type, show: true
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
