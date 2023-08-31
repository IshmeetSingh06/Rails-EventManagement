require 'rails_helper'

RSpec.describe EventsService, type: :service do
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
  let(:event) { FactoryBot.create(:event, organizer: admin) }

  describe '#create' do
    it 'creates a new event' do
      service = EventsService.new(params: params, current_user: admin)
      expect { service.create }.to change(Event, :count).by(1)
    end
  end

  describe '#update' do
    it 'updates the event' do
      service = EventsService.new(params: { name: 'new_event_name' })
      service.update(event.id)
      event.reload
      expect(event.name).to eq('new_event_name')
    end
  end

  describe '#cancel' do
    it 'cancels the event' do
      service = EventsService.new
      service.cancel(event.id)
      event.reload
      expect(event.cancelled).to be_truthy
    end

    it 'returns an error message when the event is not found' do
      service = EventsService.new
      service.cancel(9999)
      expect(service.errors).to eq('Event not found')
    end
  end

  describe '#list_all' do
    it 'loads a list of all events' do
      FactoryBot.create_list(:event, 3)
      service = EventsService.new
      events = service.list_all
      expect(events.count).to eq(3)
    end

    it 'returns an error message when no events are present' do
      service = EventsService.new
      events = service.list_all
      expect(events).to be_empty
    end
  end

  describe '#list_all_organized' do
    it 'loads a list of events organized by the user' do
      FactoryBot.create_list(:event, 3, organizer: admin)
      service = EventsService.new(current_user: admin)
      events = service.list_all_organized
      expect(events.count).to eq(3)
    end

    it 'returns an error message when the user has not organized any events' do
      service = EventsService.new(current_user: admin)
      events = service.list_all_organized
      expect(events).to be_empty
    end
  end

  describe '#list_registrations' do
    it 'returns a list of registrations for the event' do
      FactoryBot.create_list(:registration, 3, event: event)
      service = EventsService.new
      registrations = service.list_registrations(event.id)
      expect(registrations.count).to eq(3)
    end

    it 'returns an error message when the event is not found' do
      service = EventsService.new
      registrations = service.list_registrations(9999)
      expect(registrations).to eq('Event not found')
    end
  end
end
