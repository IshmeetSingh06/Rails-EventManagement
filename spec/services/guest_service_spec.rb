require 'rails_helper'

RSpec.describe GuestService, type: :service do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, role: 'admin') }
  let(:event) { FactoryBot.create(:event, organizer: admin) }
  let(:params) do
    {
      username: 'testuser',
      email: 'test@example.com',
      password: 'password',
      first_name: 'John',
      last_name: 'Doe'
    }
  end

  describe '#register' do
    it 'create a user with valid attributes' do
      service = GuestService.new(params: params)
      expect { service.register }.to change(User, :count).by(1)
      expect(service.authentication_token).to be_present
    end
  end

  describe '#update' do
    it 'updates the user with valid attributes' do
      service = GuestService.new(
        params: { "first_name" => 'new_test_name', "password" => 'password123' }, current_user: user
      )
      service.update
      user.reload
      expect(user.first_name).to eq('new_test_name')
    end
  end

  describe '#attended_events' do
    it 'loads list of events attended by the user' do
      FactoryBot.create(:registration, user: user, event: event)
      service = GuestService.new(current_user: user)
      attended_events = service.attended_events
      expect(attended_events.count).to eq(1)
    end

    it 'loads an empty list when the user has not attended any events' do
      service = GuestService.new(current_user: user)
      attended_events = service.attended_events
      expect(attended_events).to be_empty
    end
  end

  describe '#register_event_attendee' do
    it 'register the user for an event' do
      service = GuestService.new(current_user: user)
      service.register_event_attendee(event.id)
      registrations = event.registrations
      expect(registrations.count).to eq(1)
      expect(registrations.first.user).to eq(user)
    end
  end

  describe '#list_upcoming_events' do
    it 'loads the list of upcoming events' do
      event.reload
      service = GuestService.new
      upcoming_events = service.list_upcoming_events(1)
      expect(upcoming_events.count).to eq(1)
    end
  end
end
