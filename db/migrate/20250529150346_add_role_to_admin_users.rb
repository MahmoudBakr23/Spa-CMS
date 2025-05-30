class AddRoleToAdminUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :admin_users, :role, :string
  end
end
