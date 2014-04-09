class AddLocaleReferenceToBroadcastTranslate < ActiveRecord::Migration
  def change
    add_reference :broadcast_translates, :locale
  end
end
