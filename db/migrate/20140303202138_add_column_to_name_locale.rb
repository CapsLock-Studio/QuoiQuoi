class AddColumnToNameLocale < ActiveRecord::Migration
  def change
    add_column :locales, :name, :string
  end
end
