require 'rails_helper'

RSpec.describe Event, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:location) }
  it { is_expected.to validate_presence_of(:organizer_id) }
  it { is_expected.to validate_presence_of(:time) }
  it { is_expected.to validate_numericality_of(:capacity).is_greater_than(0) }
  it { is_expected.to belong_to(:organizer).class_name('User').with_foreign_key('organizer_id') }
  it { is_expected.to have_many(:registrations) }
  it { is_expected.to have_many(:attendees).through(:registrations).source(:user) }

  it 'has an active scope' do
    active_event = FactoryBot.create(:event, cancelled: false)
    inactive_event = FactoryBot.create(:event, cancelled: true)
    expect(Event.active).to include(active_event)
    expect(Event.active).not_to include(inactive_event)
  end

  it 'has an upcoming scope' do
    event = FactoryBot.create(:event, time: 1.day.from_now)
    expect(Event.upcoming).to include(event)
  end

  it 'validates that an already cancelled event cannot be updated' do
    event = FactoryBot.create(:event, cancelled: true)
    event.update(name: 'New Name')
    expect(event.errors.full_messages).to include('Event is already cancelled')
  end
end
