ActiveAdmin.register Client do
  menu if: proc { %w[admin secretary].include?(current_admin_user.role) }
  menu label: proc { I18n.t("activerecord.models.client.other") }

  permit_params :first_name, :last_name, :phone, :email

  filter :first_name
  filter :last_name
  filter :phone
  filter :email
  filter :created_at

  index do
    selectable_column
    id_column
    column I18n.t("activerecord.attributes.client.first_name"), :first_name
    column I18n.t("activerecord.attributes.client.last_name"), :last_name
    column I18n.t("activerecord.attributes.client.phone"), :phone
    column I18n.t("activerecord.attributes.client.email"), :email
    column I18n.t("activerecord.attributes.client.created_at"), :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row I18n.t("activerecord.attributes.client.first_name"), :first_name
      row I18n.t("activerecord.attributes.client.last_name"), :last_name
      row I18n.t("activerecord.attributes.client.phone"), :phone
      row I18n.t("activerecord.attributes.client.email"), :email
      row I18n.t("activerecord.attributes.client.created_at"), :created_at
      row I18n.t("activerecord.attributes.client.updated_at"), :updated_at
    end
  end

  form do |f|
    f.inputs I18n.t("activerecord.models.client.one") do
      f.input :first_name, label: I18n.t("activerecord.attributes.client.first_name")
      f.input :last_name, label: I18n.t("activerecord.attributes.client.last_name")
      f.input :phone, label: I18n.t("activerecord.attributes.client.phone")
      f.input :email, label: I18n.t("activerecord.attributes.client.email")
    end
    f.actions
  end
end
