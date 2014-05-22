class CreateTravelInformations < ActiveRecord::Migration
  def change
    create_table :travel_informations do |t|
      t.references :area, index: true
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
