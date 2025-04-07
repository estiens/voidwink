class StatsController < ApplicationController
  http_basic_authenticate_with name: ENV["STATS_USERNAME"], password: ENV["STATS_PASSWORD"]
  skip_before_action :track_visit

  def index
    @stats = {
      last_30_min: {
        total: SiteVisit.in_last_minutes(30).count,
        unique: SiteVisit.unique_visitors_in_last_minutes(30)
      },
      last_24h: {
        total: SiteVisit.in_last_hours(24).count,
        unique: SiteVisit.unique_visitors_in_last_hours(24)
      },
      last_7d: {
        total: SiteVisit.in_last_days(7).count,
        unique: SiteVisit.unique_visitors_in_last_days(7)
      },
      last_30d: {
        total: SiteVisit.in_last_days(30).count,
        unique: SiteVisit.unique_visitors_in_last_days(30)
      }
    }
  end
end
