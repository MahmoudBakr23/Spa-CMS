ActiveAdmin.register AdminUser do
  menu if: proc { current_admin_user.role == "admin" }
  menu label: proc { I18n.t("activerecord.models.admin_user.other") }

  permit_params :email, :password, :password_confirmation, :role

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  index do
    selectable_column
    id_column
    column I18n.t("activerecord.attributes.admin_user.email"), :email
    column I18n.t("activerecord.attributes.admin_user.role"), :role
    column I18n.t("activerecord.attributes.admin_user.current_sign_in_at"), :current_sign_in_at
    column I18n.t("activerecord.attributes.admin_user.sign_in_count"), :sign_in_count
    column I18n.t("activerecord.attributes.admin_user.created_at"), :created_at
    actions
  end

  form do |f|
    f.inputs I18n.t("activerecord.models.admin_user.one") do
      f.input :email, label: I18n.t("activerecord.attributes.admin_user.email")
      f.input :password, label: I18n.t("activerecord.attributes.admin_user.password")
      f.input :password_confirmation, label: I18n.t("forms.password_confirmation")
      f.input :role,
              label: I18n.t("activerecord.attributes.admin_user.role"),
              as: :select,
              collection: AdminUser::ROLES
    end
    f.actions
  end
end
