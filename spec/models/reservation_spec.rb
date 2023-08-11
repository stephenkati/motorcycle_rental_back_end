require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'associations' do
    it 'should belong to users' do
      expect(Reservation.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it 'should belong to motorcycles' do
      expect(Reservation.reflect_on_association(:motorcycle).macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    let(:reservation) { create(:reservation) }

    it 'is valid with valid attributes' do
      expect(reservation).to be_valid
    end

    it 'is not valid without a city' do
      reservation.city = nil
      expect(reservation).to_not be_valid
    end

    it 'is not valid without a reserve_date' do
      reservation.reserve_date = nil
      expect(reservation).to_not be_valid
    end

    it 'is not valid when reserve_date is less than today' do
      reservation.reserve_date = Date.today - 1
      expect(reservation).to_not be_valid
    end

    it 'is not valid without a user' do
      reservation.user = nil
      expect(reservation).to_not be_valid
    end

    it 'is not valid without a motorcycle' do
      reservation.motorcycle = nil
      expect(reservation).to_not be_valid
    end

    it 'is an instance of reservation' do
      expect(reservation).to be_an_instance_of(Reservation)
    end
  end
end
