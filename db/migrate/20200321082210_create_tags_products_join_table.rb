class CreateTagsProductsJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :products, :product_tags  do |t|
      t.index :product_id
      t.index :product_tag_id
    end
  end
end
