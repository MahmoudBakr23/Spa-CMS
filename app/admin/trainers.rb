ActiveAdmin.register Trainer do
  menu if: proc { %w[admin secretary].include?(current_admin_user.role) }
  menu label: proc { I18n.t("activerecord.models.trainer.other") }

  permit_params :first_name, :last_name, :phone, :admin_user_id

  filter :first_name
  filter :last_name
  filter :phone
  filter :admin_user
  filter :created_at

  index do
    selectable_column
    id_column
    column I18n.t("activerecord.attributes.trainer.first_name"), :first_name
    column I18n.t("activerecord.attributes.trainer.last_name"), :last_name
    column I18n.t("activerecord.attributes.trainer.phone"), :phone
    column I18n.t("activerecord.models.admin_user.one") do |trainer|
      link_to trainer.admin_user.email, admin_admin_user_path(trainer.admin_user)
    end
    column I18n.t("activerecord.attributes.trainer.created_at"), :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row I18n.t("activerecord.attributes.trainer.first_name"), :first_name
      row I18n.t("activerecord.attributes.trainer.last_name"), :last_name
      row I18n.t("activerecord.attributes.trainer.phone"), :phone
      row I18n.t("activerecord.models.admin_user.one"), :admin_user
      row I18n.t("activerecord.attributes.trainer.created_at"), :created_at
      row I18n.t("activerecord.attributes.trainer.updated_at"), :updated_at
    end

    if current_admin_user.role == "admin"
      # Upcoming Sessions Panel
      panel I18n.t("dashboard.upcoming_sessions") do
        upcoming_sessions = trainer.sessions
                                   .where("perform_at >= ?", Time.current)
                                   .order(:perform_at)

        if upcoming_sessions.any?
          table_for upcoming_sessions do
            column I18n.t("activerecord.models.client.one") do |s|
              s.client.full_name
            end
            column I18n.t("activerecord.models.service.one") do |s|
              s.service.name
            end
            column I18n.t("activerecord.attributes.session.perform_at"), &:perform_at
            column I18n.t("activerecord.attributes.session.status"), &:status
            column I18n.t("activerecord.attributes.session.notes"), &:notes
            column I18n.t("forms.actions") do |s|
              link_to I18n.t("common.view"), admin_session_path(s)
            end
          end
        else
          div I18n.t("common.no_data")
        end
      end

      # Past Sessions Panel
      panel I18n.t("forms.past_sessions", default: "Past Sessions") do
        past_sessions = trainer.sessions
                               .where("perform_at < ?", Time.current)
                               .order(perform_at: :desc)

        if past_sessions.any?
          table_for past_sessions do
            column I18n.t("activerecord.models.client.one") do |s|
              s.client.full_name
            end
            column I18n.t("activerecord.models.service.one") do |s|
              s.service.name
            end
            column I18n.t("activerecord.attributes.session.perform_at"), &:perform_at
            column I18n.t("activerecord.attributes.session.status"), &:status
            column I18n.t("activerecord.attributes.session.notes"), &:notes
            column I18n.t("forms.actions") do |s|
              link_to I18n.t("common.view"), admin_session_path(s)
            end
          end
        else
          div I18n.t("common.no_data")
        end
      end
    end
  end


  form do |f|
    f.inputs I18n.t("activerecord.models.trainer.one") do
      f.input :first_name, label: I18n.t("activerecord.attributes.trainer.first_name")
      f.input :last_name, label: I18n.t("activerecord.attributes.trainer.last_name")
      f.input :phone, label: I18n.t("activerecord.attributes.trainer.phone")
      f.input :admin_user,
              label: I18n.t("activerecord.models.admin_user.one"),
              as: :select,
              collection: AdminUser.all.map { |u| [ u.email, u.id ] }
    end
    f.actions
  end
end
