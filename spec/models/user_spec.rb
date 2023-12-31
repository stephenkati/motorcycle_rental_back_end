require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user) { create(:user) }

    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'should validate values' do
      expect(user.username).to be_a(String)
      expect(user.email).to be_a(String)
      expect(user.password).to be_a(String)
    end

    it 'should validate presence' do
      expect(user.username).to be_present
      expect(user.email).to be_present
      expect(user.password).to be_present
    end

    it 'should fail without username' do
      user.username = nil
      expect(user).to_not be_valid
    end

    it 'should fail without email' do
      user.email = nil
      expect(user).to_not be_valid
    end

    it 'should fail without password' do
      user.password = nil
      expect(user).to_not be_valid
    end
  end

  describe 'associations' do
    it 'should have many reservations' do
      expect(User.reflect_on_association(:reservations).macro).to eq(:has_many)
    end
  end
end
