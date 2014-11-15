class PastWorkTypeTranslate < ActiveRecord::Base
  belongs_to :past_work_type
  belongs_to :locale
end
