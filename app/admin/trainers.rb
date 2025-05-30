ActiveAdmin.register Trainer do
  menu if: proc { %w[admin secretary].include?(current_admin_user.role) }

  permit_params :first_name, :last_name, :phone, :admin_user_id

  filter :first_name
  filter :last_name
  filter :phone
  filter :admin_user
  filter :created_at

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :phone
    column("Admin User") { |trainer| link_to trainer.admin_user.email, admin_admin_user_path(trainer.admin_user) }
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :phone
      row :admin_user
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :phone
      f.input :admin_user, as: :select, collection: AdminUser.all.map { |u| [ u.email, u.id ] }
    end
    f.actions
  end
end
