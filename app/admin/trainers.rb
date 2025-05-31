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

    if current_admin_user.role == "admin"
      # Upcoming Sessions Panel
      panel "Upcoming Sessions" do
        upcoming_sessions = trainer.sessions
                                   .where("perform_at >= ?", Time.current)
                                   .order(:perform_at)

        if upcoming_sessions.any?
          table_for upcoming_sessions do
            column("Client") { |s| s.client.full_name }
            column("Service") { |s| s.service.name }
            column("Date & Time", &:perform_at)
            column("Status", &:status)
            column("Notes", &:notes)
            column("Actions") { |s| link_to "View", admin_session_path(s) }
          end
        else
          div "No upcoming sessions."
        end
      end

      # Past Sessions Panel
      panel "Past Sessions" do
        past_sessions = trainer.sessions
                               .where("perform_at < ?", Time.current)
                               .order(perform_at: :desc)

        if past_sessions.any?
          table_for past_sessions do
            column("Client") { |s| s.client.full_name }
            column("Service") { |s| s.service.name }
            column("Date & Time", &:perform_at)
            column("Status", &:status)
            column("Notes", &:notes)
            column("Actions") { |s| link_to "View", admin_session_path(s) }
          end
        else
          div "No past sessions."
        end
      end
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
