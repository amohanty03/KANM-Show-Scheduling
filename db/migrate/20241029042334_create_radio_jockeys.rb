class CreateRadioJockeys < ActiveRecord::Migration[7.2]
  def change
    create_table :radio_jockeys do |t|
      t.timestamps
    end
  end
end
