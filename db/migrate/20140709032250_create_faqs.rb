class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.references :locale, index: true
      t.string :question
      t.text :answer

      t.timestamps
    end
  end
end
