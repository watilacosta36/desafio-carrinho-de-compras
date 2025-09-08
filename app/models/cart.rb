class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates_numericality_of :total_price, greater_than_or_equal_to: 0
  validates :abandoned, inclusion: { in: [true, false] }

  def mark_as_abandoned
    inactivity_limit = 3.hours.ago

    if last_interaction_at < inactivity_limit
      update!(abandoned: true)
    end
  end

  def remove_if_abandoned
    if abandoned?
      destroy!
    end
  end
end
