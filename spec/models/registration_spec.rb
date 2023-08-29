require 'rails_helper'

RSpec.describe Registration, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:event) }
  it {
    expect(FactoryBot.create(:registration))
      .to validate_uniqueness_of(:user_id)
      .scoped_to(:event_id)
      .with_message('Already registered for this event')
  }
end
