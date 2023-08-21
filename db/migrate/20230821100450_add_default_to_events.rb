class AddDefaultToEvents < ActiveRecord::Migration[7.0]
  def change
    change_column_default :events, :cancelled, from: nil, to: false
  end
end
