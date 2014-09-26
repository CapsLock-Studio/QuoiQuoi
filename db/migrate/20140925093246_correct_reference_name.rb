class CorrectReferenceName < ActiveRecord::Migration
  def change
    remove_reference :materials, :material_types
    add_reference :materials, :material_type
  end
end
