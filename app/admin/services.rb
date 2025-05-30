ActiveAdmin.register Service do
  menu
  # Hide "New Service" button for trainers
  config.clear_action_items!

  action_item :new, only: :index do
    if %w[admin secretary].include?(current_admin_user.role)
      link_to "New Service", new_resource_path
    end
  end

  # Only allow create/edit/update for admin and secretary
  controller do
    before_action :authorize_admin_or_secretary!, only: [ :new, :create, :edit, :update, :destroy ]

    private

    def authorize_admin_or_secretary!
      unless %w[admin secretary].include?(current_admin_user.role)
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to admin_services_path
      end
    end
  end

  permit_params :name, :price, :duration

  filter :name
  filter :price
  filter :duration
  filter :created_at

  index do
    selectable_column
    id_column
    column :name
    column :price, sortable: :price do |service|
      number_to_currency service.price
    end
    column :duration do |service|
      "#{service.duration} min"
    end
    column :created_at
    # Only show actions for admin/secretary
    if %w[admin secretary].include?(current_admin_user.role)
      actions
    else
      actions defaults: false do |service|
        link_to "View", resource_path(service)
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :name
      row :price do |service|
        number_to_currency service.price
      end
      row :duration do |service|
        "#{service.duration} min"
      end
      row :created_at
      row :updated_at
    end
  end

  # Form for new/edit service
  form do |f|
    f.inputs "Service Details" do
      f.input :name
      f.input :price
      f.input :duration, hint: "Duration in minutes"
    end
    f.actions
  end
end
