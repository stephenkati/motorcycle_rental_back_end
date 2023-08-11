class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :motorcycle

  validates :city, :reserve_date, presence: true
  validate :reserve_date_greater_than_or_equal_to_today

  def reserve_date_greater_than_or_equal_to_today
    errors.add(:reserve_date, 'must be greater than or equal to today') if reserve_date && reserve_date < Date.today
  end
end
