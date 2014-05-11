class AddReferenceToPayments < ActiveRecord::Migration
  def change
    add_reference :payments, :order
    add_reference :payments, :course
  end
end
