class AddRemittanceReferencesToRemittance < ActiveRecord::Migration
  def change
    add_reference :remittance_translates, :remittance
  end
end
