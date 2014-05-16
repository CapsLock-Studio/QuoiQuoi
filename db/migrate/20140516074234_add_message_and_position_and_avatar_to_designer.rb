class AddMessageAndPositionAndAvatarToDesigner < ActiveRecord::Migration
  def change
    add_column :designer_translates, :message, :string
    add_column :designer_translates, :position, :string
    add_attachment :designers, :avatar
  end
end
