class AddAllColumnsToRadioJockeys < ActiveRecord::Migration[7.2]
  def change
    add_column :radio_jockeys, :timestamp, :string
    add_column :radio_jockeys, :UIN, :string
    add_column :radio_jockeys, :expected_grad, :string
    add_column :radio_jockeys, :member_type, :string
    add_column :radio_jockeys, :retaining, :string
    add_column :radio_jockeys, :semesters_in_KANM, :string
    add_column :radio_jockeys, :DJ_name, :string
    add_column :radio_jockeys, :best_day, :string
    add_column :radio_jockeys, :best_hour, :string
    add_column :radio_jockeys, :alt_mon, :string
    add_column :radio_jockeys, :alt_tue, :string
    add_column :radio_jockeys, :alt_wed, :string
    add_column :radio_jockeys, :alt_thu, :string
    add_column :radio_jockeys, :alt_fri, :string
    add_column :radio_jockeys, :alt_sat, :string
    add_column :radio_jockeys, :alt_sun, :string
    add_column :radio_jockeys, :un_jan, :string
    add_column :radio_jockeys, :un_feb, :string
    add_column :radio_jockeys, :un_mar, :string
    add_column :radio_jockeys, :un_apr, :string
    add_column :radio_jockeys, :un_may, :string
  end
end
