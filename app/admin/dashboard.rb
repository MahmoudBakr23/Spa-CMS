# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    if current_admin_user.admin?
      columns do
        column do
          panel "Statistics" do
            ul do
              li "Total Clients: #{Client.count}"
              li "Total Sessions: #{Session.count}"
              li "Total Revenue: #{Revenue.all.sum(:amount)} EGP"
            end
          end
        end

        column do
          panel "Recent Sessions" do
            ul do
              Session.order(created_at: :desc).limit(5).map do |session|
                li link_to(
                  "#{session.client&.full_name || 'No Client'} - #{session.service&.name || 'No Service'} at #{Time.use_zone('Africa/Cairo') { session.perform_at }.strftime("%d-%m-%Y")}",
                  admin_session_path(session)
                )
              end
            end
          end
        end
      end

    elsif current_admin_user.trainer?
      trainer = current_admin_user.trainer

      panel "Your Profile" do
        attributes_table_for trainer do
          row("Name") { |e| e.full_name }
          row("Email") { |e| e.admin_user.email }
          row :created_at
        end
      end

      columns do
        column do
          panel "Upcoming Sessions" do
            table_for trainer.sessions.where("perform_at >= ?", Time.current).order(:perform_at) do
              column("Client") { |s| s.client.full_name }
              column("Service") { |s| s.service.name }
              column("Date") { |s| s.perform_at.strftime("%d-%m-%Y %H:%M") }
              column("Status", &:status)
            end
          end
        end

        column do
          panel "Past Sessions" do
            table_for trainer.sessions.where("perform_at < ?", Time.current).order(perform_at: :desc).limit(10) do
              column("Client") { |s| s.client.full_name }
              column("Service") { |s| s.service.name }
              column("Date") { |s| s.perform_at.strftime("%d-%m-%Y %H:%M") }
              column("Status", &:status)
            end
          end
        end
      end

      panel "Your Expenses" do
        table_for trainer.expenses.order(created_at: :desc).limit(5) do
          column :category
          column :amount
          column :created_at
          column :notes
        end
      end
    else
      para "Welcome to the Dashboard."
    end
  end
end
