class AddPhoneAndNameToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :name, :string
    add_column :registrations, :phone, :string
  end
end
