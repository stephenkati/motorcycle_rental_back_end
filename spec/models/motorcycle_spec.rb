require 'rails_helper'

RSpec.describe Motorcycle, type: :model do
  describe 'validations' do
    let(:motorcycle) { create(:motorcycle) }

    it 'is valid with valid attributes' do
      expect(motorcycle).to be_valid
    end

    it 'is not valid without a name' do
      motorcycle.name = nil
      expect(motorcycle).to_not be_valid
    end

    it 'is not valid without a photo' do
      motorcycle.photo = nil
      expect(motorcycle).to_not be_valid
    end

    it 'is not valid without a description' do
      motorcycle.description = nil
      expect(motorcycle).to_not be_valid
    end

    it 'is not valid without a purchase_price' do
      motorcycle.purchase_price = nil
      expect(motorcycle).to_not be_valid
    end

    it 'is not valid with interger equal to zero' do
      motorcycle.purchase_price = 0
      motorcycle.rental_price = 0
      expect(motorcycle).to_not be_valid
    end

    it 'is not valid with interger less than zero' do
      motorcycle.purchase_price = -1
      motorcycle.rental_price = -2
      expect(motorcycle).to_not be_valid

      motorcycle.purchase_price = 0.3
      motorcycle.rental_price = 0.5
      expect(motorcycle).to_not be_valid
    end

    it 'is not valid when purchase price is not an integer' do
      motorcycle.purchase_price = 'abc'
      expect(motorcycle).to_not be_valid
    end

    it 'is not valid without a rental_price' do
      motorcycle.rental_price = nil
      expect(motorcycle).to_not be_valid
    end

    it 'is not valid when rental price is not an integer' do
      motorcycle.rental_price = 'abc'
      expect(motorcycle).to_not be_valid
    end

    it 'is an instance of Motorcycle class' do
      expect(motorcycle).to be_an_instance_of(Motorcycle)
    end
  end

  describe 'associations' do
    it 'should have many reservations' do
      expect(Motorcycle.reflect_on_association(:reservations).macro).to eq(:has_many)
    end
  end
end
