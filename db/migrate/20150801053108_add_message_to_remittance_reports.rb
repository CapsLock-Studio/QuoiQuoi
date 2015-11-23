class AddMessageToRemittanceReports < ActiveRecord::Migration
  def change
    add_column :order_remittance_reports, :message, :text
    add_column :registration_remittance_reports, :message, :text
  end
end
