# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu if: proc { %w[admin secretary].include?(current_admin_user.role) }

  menu priority: 1, label: proc { I18n.t("dashboard.title") }

  content title: proc { I18n.t("dashboard.title") } do
    if current_admin_user.admin?

      # Summary Stats
      columns do
        column max_width: "50%" do
          panel I18n.t("dashboard.total_clients") do
            h3 Client.count
          end
        end

        column max_width: "50%" do
          panel I18n.t("dashboard.total_revenue") do
            h3 "#{Revenue.sum(:amount)} #{I18n.t('dashboard.egp')}"
          end
        end

        column max_width: "50%" do
          panel I18n.t("dashboard.total_sessions") do
            h3 Session.count
          end
        end

        column max_width: "50%" do
          panel I18n.t("dashboard.upcoming_sessions") do
            h3 Session.where("perform_at >= ?", Time.current).count
          end
        end
      end

      # Chart: Sessions per Day
      columns do
        column do
          panel I18n.t("dashboard.sessions_per_day") do
            data = [
              {
                name: I18n.t("activerecord.models.session.other"),
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
          panel I18n.t("dashboard.revenue_per_day") do
            data = [
              {
                name: I18n.t("activerecord.models.revenue.other"),
                data: Revenue.group_by_day(:created_at, range: 30.days.ago..Time.current).sum(:amount)
              }
            ]
            line_chart data, suffix: " #{I18n.t('dashboard.egp')}", download: true
          end
        end
      end

      # Chart: Sessions by Service
      columns do
        column do
          panel I18n.t("dashboard.sessions_by_service") do
            pie_chart Session.joins(:service).group("services.name").count, download: true
          end
        end

        column do
          panel I18n.t("dashboard.revenue_by_service") do
            pie_chart Revenue.joins(session: :service).group("services.name").sum(:amount), suffix: " #{I18n.t('dashboard.egp')}", download: true
          end
        end
      end

      # Latest 5 Sessions
      panel I18n.t("dashboard.latest_sessions") do
        table_for Session.order(created_at: :desc).limit(5) do
          column(I18n.t("activerecord.models.client.one")) { |s| s.client&.full_name || "N/A" }
          column(I18n.t("activerecord.models.service.one")) { |s| s.service&.name || "N/A" }
          column(I18n.t("activerecord.models.trainer.one")) { |s| s.trainer&.full_name || "N/A" }
          column(I18n.t("activerecord.attributes.session.perform_at")) { |s| s.perform_at.strftime("%d-%m-%Y %H:%M") }
          column(I18n.t("activerecord.attributes.session.status"), &:status)
          column("") { |s| link_to I18n.t("common.view"), admin_session_path(s) }
        end
      end

    elsif current_admin_user.trainer?
      # Trainer View (unchanged for now, let me know if you want to refine this too)
      # ...
      para I18n.t("dashboard.trainer_dashboard", default: "Trainer Dashboard")
    else
      para I18n.t("dashboard.welcome", default: "Welcome to the Dashboard.")
    end
  end
end
