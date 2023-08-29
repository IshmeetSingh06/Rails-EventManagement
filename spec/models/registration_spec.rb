require 'rails_helper'

RSpec.describe Registration, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:event) }
  it "validates the unquieness of user_id" do
    user = FactoryBot.create(:user)
    event = FactoryBot.create(:event, organizer: user)
    expect(
      FactoryBot.create(
        :registration,
        user: user,
        event: event
      )
    )
      .to validate_uniqueness_of(:user_id)
      .scoped_to(:event_id)
      .with_message('Already registered for this event')
  end
end
