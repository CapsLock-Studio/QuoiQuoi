class BroadcastTranslate < ActiveRecord::Base
  belongs_to :broadcast
  belongs_to :locale

end
