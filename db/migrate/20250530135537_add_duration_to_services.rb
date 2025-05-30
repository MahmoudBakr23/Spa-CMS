class AddDurationToServices < ActiveRecord::Migration[8.0]
  def change
    add_column :services, :duration, :integer
  end
end
