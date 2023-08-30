require 'rails_helper'

RSpec.describe "Events", type: :request do
  let(:params) do
    {
      name: "Test event",
      description: "Lorem ipsum hhehre",
      location: "New York",
      time: 1.day.from_now,
      capacity: 100
    }
  end
  let(:admin) { FactoryBot.create(:user, role: 'admin') }
  let(:guest) { FactoryBot.create(:user, role: 'guest') }
  let(:event) { FactoryBot.create(:event, organizer: admin) }
  let(:admin_header) { { 'Authorization' => admin.authentication_token } }
  let(:guest_header) { { 'Authorization' => guest.authentication_token } }

  describe "get #index" do
    it "loads the list of events" do
      get api_v1_events_path, headers: admin_header
      expect(response).to be_successful
    end
  end

  describe "post #create" do
    it "creates a new event" do
      expect do
        post api_v1_events_path, params: { event: params }, headers: admin_header
      end.to change(Event, :count).by(1)
    end
  end

  describe "put #update" do
    it "updates the event" do
      expect do
        put api_v1_event_path(event.id),
          params: { event: { name: Faker::Name.name } },
          headers: admin_header
      end.to change {
        Event.find(event.id).name
      }
    end
  end

  describe "put #cancel" do
    it "sets cancelled true in event" do
      put cancel_api_v1_event_path(event.id), headers: admin_header
      event.reload
      expect(response).to be_successful
      expect(event.cancelled).to eq(true)
    end
  end

  describe 'get #organized' do
    it 'loads the list of events organized by the admin' do
      get organized_api_v1_events_path, headers: admin_header
      expect(response).to be_successful
    end
  end

  describe 'get #registrations' do
    it 'loads the list of registrations for an event' do
      FactoryBot.create(:registration, user: guest, event: event)
      get registrations_api_v1_event_path(event.id), headers: admin_header
      expect(response).to be_successful
    end
  end

  describe 'get #upcoming' do
    it 'loads the list of upcoming events' do
      get upcoming_api_v1_events_path, headers: guest_header
      expect(response).to be_successful
    end
  end
end
