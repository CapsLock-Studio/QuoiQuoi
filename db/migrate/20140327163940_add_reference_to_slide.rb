class AddReferenceToSlide < ActiveRecord::Migration
  def change
    remove_column :slides, :position
    add_reference :slides, :slide_positions
  end
end
