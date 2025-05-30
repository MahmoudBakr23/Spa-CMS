ActiveAdmin.register Client do
  menu if: proc { %w[admin secretary].include?(current_admin_user.role) }

  permit_params :first_name, :last_name, :phone, :email

  filter :first_name
  filter :last_name
  filter :phone
  filter :email
  filter :created_at

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :phone
    column :email
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :phone
      row :email
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :phone
      f.input :email
    end
    f.actions
  end
end
