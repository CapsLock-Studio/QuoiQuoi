class AddReasonToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :reason, :text
  end
end
