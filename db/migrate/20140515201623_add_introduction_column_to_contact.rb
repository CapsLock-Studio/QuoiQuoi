class AddIntroductionColumnToContact < ActiveRecord::Migration
  def change
    add_column :contact_translates, :introduction, :text
  end
end
