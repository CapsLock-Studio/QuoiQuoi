class CreateProductYoutubes < ActiveRecord::Migration
  def change
    create_table :product_youtubes do |t|
      t.references :product, show: true
      t.string :link

      t.timestamps
    end
  end
end
