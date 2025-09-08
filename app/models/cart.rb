class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates_numericality_of :total_price, greater_than_or_equal_to: 0
  validates :abandoned, inclusion: { in: [true, false] }

  def self.mark_inactive_as_abandoned
    inactive_carts = where(abandoned: false).where('last_interaction_at < ?', 3.hours.ago)
    inactive_carts.update_all(abandoned: true, updated_at: Time.current)
  end

  def self.remove_old_abandoned
    old_abandoned_carts = where(abandoned: true).where('updated_at < ?', 7.days.ago)
    old_abandoned_carts.destroy_all
  end
end
