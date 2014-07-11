class AddSlideTranslateAndBroacastLink < ActiveRecord::Migration
  def change
    add_column :slide_translates, :link, :string
    add_column :broadcast_translates, :link, :string
    remove_column :slides, :link
    remove_column :broadcasts, :link
  end
end
