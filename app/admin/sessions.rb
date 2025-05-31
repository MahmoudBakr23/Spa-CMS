ActiveAdmin.register Session do
  menu if: proc { %w[admin secretary].include?(current_admin_user.role) }

  permit_params :client_id, :service_id, :trainer_id, :perform_at, :status, :notes

  filter :service
  filter :trainer
  filter :perform_at
  filter :status, as: :select, collection: Session::STATUSES

  index do
    selectable_column
    id_column
    column :client
    column :service
    column :trainer
    column :perform_at
    column :status
    actions defaults: true do |session|
      unless session.refunded? || session.performed?
        item "Refund", refund_admin_session_path(session), method: :put, class: "member_link"
      end
    end
  end

  show do
    attributes_table do
      row :client
      row :service
      row :trainer
      row :perform_at
      row :status
      row :notes
      row :created_at
      row :updated_at
    end

    panel "Revenue" do
      if session.revenue
        attributes_table_for session.revenue do
          row :amount
          row :created_at
        end
      else
        div "No revenue generated"
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :client,
              collection: Client.all.sort_by(&:last_name).map { |c| [c.full_name, c.id] },
              prompt: "Select a client"

      f.input :service,
              collection: Service.order(:name).map { |s| [s.name, s.id] },
              prompt: "Select a service"

      f.input :trainer,
              collection: Trainer.all.sort_by(&:last_name).map { |t| [t.full_name, t.id] },
              prompt: "Select a trainer"

      f.input :perform_at,
              as: :datetime_picker,
              input_html: { placeholder: "Choose session time" }

      f.input :status,
              as: :select,
              collection: Session::STATUSES,
              prompt: "Select status"

      f.input :notes,
              placeholder: "Optional notes about the session"
    end
    f.actions
  end

  member_action :refund, method: :put do
    session = Session.find(params[:id])
    if session.update!(status: :refunded)
      redirect_to admin_sessions_path, notice: "Session ##{session.id} has been refunded."
    else
      redirect_to admin_sessions_path, alert: "Failed to refund session."
    end
  end
end
