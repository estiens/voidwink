class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :track_visit

  private

  def track_visit
    # Only track if this is a page view (not an API call, asset, etc.)
    return unless request.format.html?

    # Get or create session ID if not exists
    session[:visitor_id] ||= SecureRandom.hex(16)

    # Record the visit
    SiteVisit.create(
      session_id: session[:visitor_id],
      visit_time: Time.current,
      path: request.path,
    )
  end
end
