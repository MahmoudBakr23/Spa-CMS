ActiveAdmin.register Revenue do
  menu if: proc { %w[admin secretary].include?(current_admin_user.role) }
  menu label: proc { I18n.t("activerecord.models.revenue.other") }

  permit_params :session_id, :amount

  filter :session_service_name, as: :string, label: I18n.t("activerecord.models.service.one")
  filter :amount
  filter :created_at

  index do
    selectable_column
    id_column

    column I18n.t("activerecord.models.session.one"), :session
    column I18n.t("activerecord.models.service.one") do |revenue|
      link_to_if revenue.session&.service,
                 revenue.session.service.name,
                 admin_service_path(revenue.session.service)
    rescue
      status_tag(I18n.t("common.no_data"), :warning)
    end

    column I18n.t("activerecord.attributes.revenue.amount") do |revenue|
      number_to_currency revenue.amount
    end

    column I18n.t("activerecord.attributes.revenue.created_at"), :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row I18n.t("activerecord.models.session.one"), :session
      row I18n.t("activerecord.models.service.one") do |revenue|
        link_to revenue.session.service.name, admin_service_path(revenue.session.service)
      rescue
        status_tag(I18n.t("common.no_data"), :warning)
      end
      row I18n.t("activerecord.attributes.revenue.amount") do
        number_to_currency revenue.amount
      end
      row I18n.t("activerecord.attributes.revenue.created_at"), :created_at
      row I18n.t("activerecord.attributes.revenue.updated_at"), :updated_at
    end
  end

  form do |f|
    f.inputs I18n.t("activerecord.models.revenue.one") do
      f.input :session, label: I18n.t("activerecord.models.session.one")
      f.input :amount, label: I18n.t("activerecord.attributes.revenue.amount")
    end
    f.actions
  end
end
