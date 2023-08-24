class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :location
      t.datetime :date_time
      t.references :organizer, null: false, foreign_key: { to_table: :users }
      t.integer :capacity
      t.boolean :cancelled

      t.timestamps
    end
  end
end
