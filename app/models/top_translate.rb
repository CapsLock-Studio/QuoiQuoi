class TopTranslate < ActiveRecord::Base
  belongs_to :top
  belongs_to :locale
end
