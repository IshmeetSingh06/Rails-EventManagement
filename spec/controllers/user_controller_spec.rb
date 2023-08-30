require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:params) do
    {
      username: 'testuser',
      email: 'test@example.com',
      password: 'password',
      first_name: 'John',
      last_name: 'Doe'
    }
  end
  let(:admin) { FactoryBot.create(:user, role: 'admin') }
  let(:guest) { FactoryBot.create(:user, role: 'guest') }
  let(:admin_header) { { 'Authorization' => admin.authentication_token } }
  let(:guest_header) { { 'Authorization' => guest.authentication_token } }

  describe "get #index" do
    it "loads the list of users" do
      get api_v1_users_path, headers: admin_header
      expect(response).to be_successful
    end
  end

  describe "post #create" do
    it "creates a new user" do
      expect do
        post api_v1_users_path, params: { user: params }
      end.to change(User, :count).by(1)
    end
  end

  describe "put #update" do
    it "updates the user" do
      expect do
        put api_v1_users_path,
          params: { user: { username: Faker::Name.name, password: guest.password } },
          headers: guest_header
      end.to change {
        User.find(guest.id).username
      }
    end
  end

  describe "put #deactive" do
    it "only inactive the user from Users" do
      debugger
      put deactivate_api_v1_user_path(guest.id), headers: admin_header
      puts response.body
      expect(response).to be_successful
      expect(guest.reload.active).to eq(false)
    end
  end

  describe 'get #events' do
    it 'loads the list of events attended by the user' do
      event = FactoryBot.create(:event, organizer: admin)
      reg = FactoryBot.create(:registration, user: guest, event: event)
      get events_api_v1_users_path, headers: guest_header
      expect(response).to be_successful
    end
  end

  describe 'post #attend_event' do
    it 'registers the user for an event' do
      event = FactoryBot.create(:event, organizer: admin)
      post attend_event_api_v1_users_path, params: { event_id: event.id }, headers: guest_header
      expect(response).to be_successful
    end
  end
end
