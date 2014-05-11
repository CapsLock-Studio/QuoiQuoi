class RentInfoTranslate < ActiveRecord::Base
  belongs_to :rent_info
  belongs_to :locale
end
