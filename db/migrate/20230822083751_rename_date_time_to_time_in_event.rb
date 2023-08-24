class RenameDateTimeToTimeInEvent < ActiveRecord::Migration[7.0]
  def change
    rename_column :events, :date_time, :time
  end
end
