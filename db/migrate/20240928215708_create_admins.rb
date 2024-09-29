class CreateAdmins < ActiveRecord::Migration[7.2]
  def change
    create_table :admins do |t|
      t.string :email
      t.string :uin
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
