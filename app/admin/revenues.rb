ActiveAdmin.register Revenue do
  menu if: proc { %w[admin secretary].include?(current_admin_user.role) }

  permit_params :session_id, :amount

  filter :session
  filter :session_service_name, as: :string, label: "Service Name"
  filter :amount
  filter :created_at

  index do
    selectable_column
    id_column

    column :session
    column "Service" do |revenue|
      link_to_if revenue.session&.service,
                 revenue.session.service.name,
                 admin_service_path(revenue.session.service)
    rescue
      status_tag("No Service", :warning)
    end

    column :amount do |revenue|
      number_to_currency revenue.amount
    end

    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :session
      row "Service" do |revenue|
        link_to revenue.session.service.name, admin_service_path(revenue.session.service)
      rescue
        status_tag("Not Available", :warning)
      end
      row :amount do
        number_to_currency revenue.amount
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :session
      f.input :amount
    end
    f.actions
  end
end
