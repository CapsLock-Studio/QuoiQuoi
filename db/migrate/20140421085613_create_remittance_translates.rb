class CreateRemittanceTranslates < ActiveRecord::Migration
  def change
    create_table :remittance_translates do |t|
      t.references :locale, index: true
      t.string :name
      t.string :account
      t.string :bank_name
      t.string :bank_address
      t.string :code

      t.timestamps
    end
  end
end
