class RequirementTranslate < ActiveRecord::Base
  belongs_to :requirement
  belongs_to :locale
end
