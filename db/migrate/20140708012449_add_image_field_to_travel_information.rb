class AddImageFieldToTravelInformation < ActiveRecord::Migration
  def change
    add_attachment :travel_informations, :image
  end
end
