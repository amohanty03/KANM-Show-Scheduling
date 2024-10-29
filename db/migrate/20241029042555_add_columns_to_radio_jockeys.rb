class AddColumnsToRadioJockeys < ActiveRecord::Migration[7.2]
  def change
    add_column :radio_jockeys, :first_name, :string
    add_column :radio_jockeys, :last_name, :string
    add_column :radio_jockeys, :show_name, :string
  end
end
