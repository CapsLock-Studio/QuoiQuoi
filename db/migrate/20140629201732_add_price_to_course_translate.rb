class AddPriceToCourseTranslate < ActiveRecord::Migration
  def change
    add_column :course_translates, :price, :float
    add_column :registrations, :currency, :string
    add_column :registrations, :locale_id, :integer
  end
end
