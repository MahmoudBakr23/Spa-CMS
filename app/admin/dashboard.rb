# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu if: proc { %w[admin secretary].include?(current_admin_user.role) }

  menu priority: 1, label: "Dashboard"

  content title: proc { "Dashboard" } do
    if current_admin_user.admin?

      # Summary Stats
      columns do
        column max_width: "50%" do
          panel "Total Clients" do
            h3 Client.count
          end
        end

        column max_width: "50%" do
          panel "Total Revenue" do
            h3 "#{Revenue.sum(:amount)} EGP"
          end
        end

        column max_width: "50%" do
          panel "Total Sessions" do
            h3 Session.count
          end
        end

        column max_width: "50%" do
          panel "Upcoming Sessions" do
            h3 Session.where("perform_at >= ?", Time.current).count
          end
        end
      end

      # Chart: Sessions per Day
      columns do
        column do
          panel "Sessions per Day (Last 30 Days)" do
            data = [
              {
                name: "Sessions",
                data: Session.group_by_day(:perform_at, range: 30.days.ago..Time.current).count
              }
            ]
            line_chart data, download: true
          end
        end
      end

      # Chart: Revenue per Day
      columns do
        column do
          panel "Revenue per Day (Last 30 Days)" do
            data = [
              {
                name: "Revenue",
                data: Revenue.group_by_day(:created_at, range: 30.days.ago..Time.current).sum(:amount)
              }
            ]
            line_chart data, suffix: " EGP", download: true
          end
        end
      end

      # Chart: Sessions by Service
      columns do
        column do
          panel "Sessions by Service" do
            pie_chart Session.joins(:service).group("services.name").count, download: true
          end
        end

        column do
          panel "Revenue by Service" do
            pie_chart Revenue.joins(session: :service).group("services.name").sum(:amount), suffix: " EGP", download: true
          end
        end
      end

      # Latest 5 Sessions
      panel "Latest Sessions" do
        table_for Session.order(created_at: :desc).limit(5) do
          column("Client") { |s| s.client&.full_name || "N/A" }
          column("Service") { |s| s.service&.name || "N/A" }
          column("Performer") { |s| s.trainer&.full_name || "N/A" }
          column("Date") { |s| s.perform_at.strftime("%d-%m-%Y %H:%M") }
          column("Status", &:status)
          column("") { |s| link_to "View", admin_session_path(s) }
        end
      end

    elsif current_admin_user.trainer?
      # Trainer View (unchanged for now, let me know if you want to refine this too)
      # ...
      para "Trainer Dashboard"
    else
      para "Welcome to the Dashboard."
    end
  end
end
