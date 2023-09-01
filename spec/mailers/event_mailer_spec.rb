require 'rails_helper'

RSpec.describe EventMailer, type: :mailer do
  let(:admin) { FactoryBot.create(:user, role: 'admin') }
  let(:event) { FactoryBot.create(:event) }
  let(:attendees) { FactoryBot.create_list(:registration, 5, event: event) }
  let(:mail) { EventMailer.cancelled(event: event) }

  describe 'cancellation_email' do
    it 'sends the email' do
      expect { mail.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('Event Cancelled')
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(event.name)
      expect(mail.body.encoded).to match('We regret to inform you that event has been cancelled.')
    end
  end
end
