class ChangeReferenceToPayment < ActiveRecord::Migration
  def change
    remove_reference :payments, :course
    add_reference :payments, :registration
  end
end
