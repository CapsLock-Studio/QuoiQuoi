class AddLinkToBroadcast < ActiveRecord::Migration
  def change
    add_column :broadcasts, :link, :string
  end
end
