require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to have_many(:registrations) }
  it { is_expected.to have_many(:organized_events).
    class_name('Event').with_foreign_key('organizer_id')
  }
  it { should define_enum_for(:status) }
  it { should allow_value('hello@hi.com').for(:email) }
  it { is_expected.to have_many(:attended_events).through(:registrations).source(:event) }
  it { is_expected.to validate_uniqueness_of(:username) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it 'generates an authentication token before create' do
    user = FactoryBot.create(:user)
    expect(user.authentication_token).not_to be_nil
  end
end
