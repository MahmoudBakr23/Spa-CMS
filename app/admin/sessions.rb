ActiveAdmin.register Session do
  menu if: proc { %w[admin secretary].include?(current_admin_user.role) }
  menu label: proc { I18n.t("activerecord.models.session.other") }

  permit_params :client_id, :service_id, :trainer_id, :perform_at, :status, :notes

  filter :service
  filter :trainer
  filter :perform_at
  filter :status, as: :select, collection: Session::STATUSES

  index do
    selectable_column
    id_column
    column I18n.t("activerecord.models.client.one"), :client
    column I18n.t("activerecord.models.service.one"), :service
    column I18n.t("activerecord.models.trainer.one"), :trainer
    column I18n.t("activerecord.attributes.session.perform_at"), :perform_at
    column I18n.t("activerecord.attributes.session.status"), :status
    actions defaults: true do |session|
      unless session.refunded? || session.performed?
        item I18n.t("forms.refund", default: "Refund"), refund_admin_session_path(session), method: :put, class: "member_link"
      end
    end
  end

  show do
    attributes_table do
      row I18n.t("activerecord.models.client.one"), :client
      row I18n.t("activerecord.models.service.one"), :service
      row I18n.t("activerecord.models.trainer.one"), :trainer
      row I18n.t("activerecord.attributes.session.perform_at"), :perform_at
      row I18n.t("activerecord.attributes.session.status"), :status
      row I18n.t("activerecord.attributes.session.notes"), :notes
      row I18n.t("activerecord.attributes.session.created_at"), :created_at
      row I18n.t("activerecord.attributes.session.updated_at"), :updated_at
    end

    panel I18n.t("activerecord.models.revenue.one") do
      if session.revenue
        attributes_table_for session.revenue do
          row I18n.t("activerecord.attributes.revenue.amount"), :amount
          row I18n.t("activerecord.attributes.revenue.created_at"), :created_at
        end
      else
        div I18n.t("common.no_data")
      end
    end
  end

  form do |f|
    f.inputs I18n.t("activerecord.models.session.one") do
      f.input :client,
              label: I18n.t("activerecord.models.client.one"),
              collection: Client.all.sort_by(&:last_name).map { |c| [ c.full_name, c.id ] },
              prompt: I18n.t("forms.select_client", default: "Select a client")

      f.input :service,
              label: I18n.t("activerecord.models.service.one"),
              collection: Service.order(:name).map { |s| [ s.name, s.id ] },
              prompt: I18n.t("forms.select_service", default: "Select a service")

      f.input :trainer,
              label: I18n.t("activerecord.models.trainer.one"),
              collection: Trainer.all.sort_by(&:last_name).map { |t| [ t.full_name, t.id ] },
              prompt: I18n.t("forms.select_trainer", default: "Select a trainer")

      f.input :perform_at,
              label: I18n.t("activerecord.attributes.session.perform_at"),
              as: :datetime_picker,
              input_html: { placeholder: I18n.t("forms.choose_time", default: "Choose session time") }

      f.input :status,
              label: I18n.t("activerecord.attributes.session.status"),
              as: :select,
              collection: Session::STATUSES,
              prompt: I18n.t("forms.select_status", default: "Select status")

      f.input :notes,
              label: I18n.t("activerecord.attributes.session.notes"),
              placeholder: I18n.t("forms.optional_notes", default: "Optional notes about the session")
    end
    f.actions
  end

  member_action :refund, method: :put do
    session = Session.find(params[:id])
    if session.update!(status: :refunded)
      redirect_to admin_sessions_path, notice: I18n.t("forms.refund_success", id: session.id, default: "Session ##{session.id} has been refunded.")
    else
      redirect_to admin_sessions_path, alert: I18n.t("forms.refund_failed", default: "Failed to refund session.")
    end
  end
end
