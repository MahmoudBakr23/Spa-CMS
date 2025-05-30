ActiveAdmin.register AdminUser do
  menu if: proc { current_admin_user.role == "admin" }

  permit_params :email, :password, :password_confirmation, :role

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  index do
    selectable_column
    id_column
    column :email
    column :role
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :role, as: :select, collection: AdminUser::ROLES
    end
    f.actions
  end
end
