require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include("must be greater than or equal to 0")
    end

    it 'validates abandoned' do
      cart = described_class.new(abandoned: "invalid")
      expect(cart.valid?).to be_falsey
    end
  end

  context 'when testing associations' do
    it { should have_many(:cart_items).dependent(:destroy) }
    it { should have_many(:products).through(:cart_items) }
  end

  describe 'mark_inactive_as_abandoned' do
    let!(:inactive_cart)          { create(:cart, abandoned: false, last_interaction_at: 4.hours.ago) }
    let!(:active_cart)            { create(:cart, abandoned: false, last_interaction_at: 1.hour.ago) }
    let!(:already_abandoned_cart) { create(:cart, abandoned: true, last_interaction_at: 5.hours.ago) }

    it 'marks only inactive, non-abandoned carts as abandoned' do
      described_class.mark_inactive_as_abandoned

      expect(inactive_cart.reload.abandoned).to be_truthy
      expect(active_cart.reload.abandoned).to be_falsey
      expect(already_abandoned_cart.reload.abandoned).to be_truthy
    end
  end

  describe 'remove_old_abandoned' do
    let!(:old_abandoned_cart)    { create(:cart, abandoned: true, updated_at: 8.days.ago) }
    let!(:recent_abandoned_cart) { create(:cart, abandoned: true, updated_at: 1.day.ago) }
    let!(:active_cart)           { create(:cart, abandoned: false, updated_at: 10.days.ago) }

    it 'removes only old abandoned carts' do
      expect { described_class.remove_old_abandoned }.to change(Cart, :count).by(-1)
      expect(Cart.exists?(old_abandoned_cart.id)).to be_falsey
      expect(Cart.exists?(recent_abandoned_cart.id)).to be_truthy
      expect(Cart.exists?(active_cart.id)).to be_truthy
    end
  end
end
