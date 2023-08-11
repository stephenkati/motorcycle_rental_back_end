class Motorcycle < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :name, :photo, :description, presence: true
  validates :purchase_price, :rental_price, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
