class AddIndexToRemittanceTranslates < ActiveRecord::Migration
  def change
    add_index :remittance_translates, :remittance_id, name: 'index remittance_trnaslates on remittance_id', using: :btree
  end
end
