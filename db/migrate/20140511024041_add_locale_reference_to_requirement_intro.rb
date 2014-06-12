class AddLocaleReferenceToRequirementIntro < ActiveRecord::Migration
  def change
    add_reference :requirement_intro_translates, :locale, show: true
  end
end
