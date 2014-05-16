class AddFbTwitterGoogleToDesigner < ActiveRecord::Migration
  def change
    add_column :designers, :facebook, :string
    add_column :designers, :twitter, :string
    add_column :designers, :google_plus, :string
    add_column :designers, :linkedin, :string
  end
end
