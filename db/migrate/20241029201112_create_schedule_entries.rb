class CreateScheduleEntries < ActiveRecord::Migration[7.2]
  def change
    create_table :schedule_entries do |t|
      t.string :day
      t.integer :hour
      t.string :show_name
      t.string :last_name
      t.integer :jockey_id

      t.timestamps
    end
  end
end
