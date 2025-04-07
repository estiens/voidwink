require 'rails_helper'

RSpec.feature "Site Visit Tracking", type: :feature do
  scenario "tracks a visit when viewing a page" do
    expect {
      visit root_path
    }.to change(SiteVisit, :count).by(1)

    last_visit = SiteVisit.last
    expect(last_visit.path).to eq('/')
    expect(last_visit.session_id).to be_present
    expect(last_visit.visit_time).to be_present
  end

  scenario "does not track non-HTML requests" do
    expect {
      page.driver.header 'Accept', 'application/json'
      visit root_path
    }.not_to change(SiteVisit, :count)
  end

  scenario "maintains the same session ID across multiple visits" do
    visit root_path
    first_visit = SiteVisit.last
    first_session_id = first_visit.session_id

    visit about_path
    second_visit = SiteVisit.last

    expect(second_visit.session_id).to eq(first_session_id)
    expect(SiteVisit.where(session_id: first_session_id).count).to eq(2)
  end
end
