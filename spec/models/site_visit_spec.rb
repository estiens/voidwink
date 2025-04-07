require 'rails_helper'

RSpec.describe SiteVisit, type: :model do
  describe 'attributes' do
    it 'has expected attributes' do
      site_visit = SiteVisit.new(
        session_id: 'abc123',
        visit_time: Time.current,
        path: '/home'
      )

      expect(site_visit.session_id).to eq('abc123')
      expect(site_visit.visit_time).to be_present
      expect(site_visit.path).to eq('/home')
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      site_visit = SiteVisit.new(
        session_id: 'abc123',
        visit_time: Time.current,
        path: '/home'
      )
      expect(site_visit).to be_valid
    end

    it 'requires a session_id' do
      site_visit = SiteVisit.new(visit_time: Time.current, path: '/home')
      expect(site_visit).not_to be_valid
    end

    it 'requires a visit_time' do
      site_visit = SiteVisit.new(session_id: 'abc123', path: '/home')
      expect(site_visit).not_to be_valid
    end

    it 'requires a path' do
      site_visit = SiteVisit.new(session_id: 'abc123', visit_time: Time.current)
      expect(site_visit).not_to be_valid
    end
  end

  describe 'scopes' do
    before do
      # Create visits at different times
      @now = Time.current
      travel_to(@now) do
        # Current visit
        create(:site_visit, session_id: 'user1', visit_time: @now)

        # 15 minutes ago
        create(:site_visit, session_id: 'user1', visit_time: 15.minutes.ago)

        # 2 hours ago
        create(:site_visit, session_id: 'user2', visit_time: 2.hours.ago)

        # 3 days ago
        create(:site_visit, session_id: 'user3', visit_time: 3.days.ago)

        # 15 days ago
        create(:site_visit, session_id: 'user4', visit_time: 15.days.ago)

        # 45 days ago (outside our tracking window)
        create(:site_visit, session_id: 'user5', visit_time: 45.days.ago)
      end
    end

    describe '.in_last_minutes' do
      it 'returns visits within the specified minutes' do
        travel_to(@now) do
          expect(SiteVisit.in_last_minutes(20).count).to eq(2)
          expect(SiteVisit.in_last_minutes(10).count).to eq(1)
        end
      end
    end

    describe '.in_last_hours' do
      it 'returns visits within the specified hours' do
        travel_to(@now) do
          expect(SiteVisit.in_last_hours(3).count).to eq(3)
          expect(SiteVisit.in_last_hours(1).count).to eq(2)
        end
      end
    end

    describe '.in_last_days' do
      it 'returns visits within the specified days' do
        travel_to(@now) do
          expect(SiteVisit.in_last_days(4).count).to eq(4)
          expect(SiteVisit.in_last_days(30).count).to eq(5)
        end
      end
    end

    describe 'unique visitor counts' do
      it 'counts unique visitors in last minutes' do
        travel_to(@now) do
          expect(SiteVisit.unique_visitors_in_last_minutes(20)).to eq(1) # only user1 in last 20 min
          expect(SiteVisit.unique_visitors_in_last_minutes(60)).to eq(1) # still only user1
        end
      end

      it 'counts unique visitors in last hours' do
        travel_to(@now) do
          expect(SiteVisit.unique_visitors_in_last_hours(3)).to eq(2) # user1 and user2
          expect(SiteVisit.unique_visitors_in_last_hours(1)).to eq(1) # only user1
        end
      end

      it 'counts unique visitors in last days' do
        travel_to(@now) do
          expect(SiteVisit.unique_visitors_in_last_days(4)).to eq(3) # user1, user2, and user3
          expect(SiteVisit.unique_visitors_in_last_days(30)).to eq(4) # user1 through user4
        end
      end
    end
  end
end
