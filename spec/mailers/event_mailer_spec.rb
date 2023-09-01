require 'rails_helper'

RSpec.describe EventMailer, type: :mailer do
  let(:event) { FactoryBot.create(:event) }
  let(:user) { FactoryBot.create(:user) }
  let(:mail) { EventMailer.cancelled(user: user, event: event) }

  describe 'event_cancellation_email' do
    it 'renders the headers' do
      expect(mail.subject).to eq('Event Cancelled')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(user.first_name)
      expect(mail.body.encoded).to match(event.name)
      expect(mail.body.encoded).to match('We regret to inform you that event has been cancelled.')
    end
  end
end
