class AddRemainingMonths < ActiveRecord::Migration[7.2]
  def change
    add_column :radio_jockeys, :un_jun, :string
    add_column :radio_jockeys, :un_jul, :string
    add_column :radio_jockeys, :un_aug, :string
    add_column :radio_jockeys, :un_sep, :string
    add_column :radio_jockeys, :un_oct, :string
    add_column :radio_jockeys, :un_nov, :string
    add_column :radio_jockeys, :un_dec, :string
  end
end
