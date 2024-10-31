class RenameColumns < ActiveRecord::Migration[7.2]
  def change
    rename_column :radio_jockeys, :UIN, :uin
    rename_column :radio_jockeys, :semesters_in_KANM, :semesters_in_kanm
    rename_column :radio_jockeys, :DJ_name, :dj_name
  end
end
