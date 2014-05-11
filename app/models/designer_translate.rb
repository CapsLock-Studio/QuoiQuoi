class DesignerTranslate < ActiveRecord::Base
  belongs_to :designer
  belongs_to :locale
end
