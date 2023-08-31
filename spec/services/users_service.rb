require 'rails_helper'

RSpec.describe UsersService, type: :service do
  let(:user) { FactoryBot.create(:user) }

  describe '#deactivate' do
    context 'when the user is found' do
      it 'deactivates the user' do
        service = UsersService.new
        service.deactivate(user.id)
        user.reload
        expect(user.active).to be false
      end
    end

    it 'returns an error message when the user is not found' do
      service = UsersService.new
      service.deactivate(9999)
      expect(service.errors).to eq('User not found')
    end
  end

  describe '#list_all' do
    it 'loads a list of all users' do
      FactoryBot.create_list(:user, 3)
      service = UsersService.new
      users = service.list_all
      expect(users.count).to eq(3)
    end

    it 'loads an empty list if no users exist' do
      service = UsersService.new
      users = service.list_all
      expect(users.count).to eq(0)
    end
  end
end
