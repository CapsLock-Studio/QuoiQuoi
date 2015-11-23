class ChangePropertyToRemittanceReports < ActiveRecord::Migration
  def change
    change_column :order_remittance_reports, :account, :string
    change_column :registration_remittance_reports, :account, :string
  end
end
