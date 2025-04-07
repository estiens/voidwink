class SiteVisit < ApplicationRecord
  validates :session_id, presence: true
  validates :visit_time, presence: true
  validates :path, presence: true

  scope :in_last_minutes, ->(minutes) { where("visit_time >= ?", minutes.minutes.ago) }
  scope :in_last_hours, ->(hours) { where("visit_time >= ?", hours.hours.ago) }
  scope :in_last_days, ->(days) { where("visit_time >= ?", days.days.ago) }

  def self.unique_visitors_in_last_minutes(minutes)
    in_last_minutes(minutes).distinct.count(:session_id)
  end

  def self.unique_visitors_in_last_hours(hours)
    in_last_hours(hours).distinct.count(:session_id)
  end

  def self.unique_visitors_in_last_days(days)
    in_last_days(days).distinct.count(:session_id)
  end
end
