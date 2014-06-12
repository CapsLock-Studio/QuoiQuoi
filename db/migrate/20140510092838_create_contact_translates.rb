class CreateContactTranslates < ActiveRecord::Migration
  def change
    create_table :contact_translates do |t|
      t.references :contact, show: true
      t.references :locale, show: true
      t.string :email
      t.string :phone
      t.string :mobile

      t.timestamps
    end
  end
end
