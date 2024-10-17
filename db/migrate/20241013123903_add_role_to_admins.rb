class AddRoleToAdmins < ActiveRecord::Migration[7.2]
  def change
    add_column :admins, :role, :integer, default: 0
  end
end
