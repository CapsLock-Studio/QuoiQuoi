class CorrectSlideReference < ActiveRecord::Migration
  def change
    remove_reference :slides, :slide_positions
    add_reference :slides, :slide_position
  end
end
