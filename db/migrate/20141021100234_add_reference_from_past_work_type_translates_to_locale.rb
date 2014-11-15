class AddReferenceFromPastWorkTypeTranslatesToLocale < ActiveRecord::Migration
  def change
    add_reference :past_work_type_translates, :locale, index: true
  end
end
