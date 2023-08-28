require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = FactoryBot.create(:user)
    expect(user).to be_valid
  end

  it 'is not valid without a username' do
    user = FactoryBot.create(:user, username: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid without an email' do
    user = FactoryBot.create(:user, email: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid with an invalid email format' do
    user = FactoryBot.create(:user, email: 'invalid_email')
    expect(user).not_to be_valid
  end

  it 'is not valid without a password' do
    user = FactoryBot.create(:user, password: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid without a first_name' do
    user = FactoryBot.create(:user, first_name: nil)
    expect(user).not_to be_valid
  end

  it 'is valid without a last_name' do
    user = FactoryBot.create(:user, last_name: nil)
    expect(user).to be_valid
  end

  it 'has many registrations' do
    expect(User.reflect_on_association(:registrations).macro).to eq(:has_many)
  end

  it 'has many organized_events' do
    expect(User.reflect_on_association(:organized_events).macro).to eq(:has_many)
  end

  it 'has many attended_events through registrations' do
    expect(User.reflect_on_association(:attended_events).macro).to eq(:has_many)
  end

  it 'has an enum for role' do
    expect(User.roles.keys).to include('admin', 'guest')
  end

  it 'generates an authentication token before create' do
    user = FactoryBot.create(:user)
    expect(user.authentication_token).not_to be_nil
  end
end
