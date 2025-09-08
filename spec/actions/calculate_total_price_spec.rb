# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateTotalPrice, type: :action do
  subject(:result) { described_class.execute(ctx) }
  let(:ctx) { { cart: cart } }

  context 'when the cart has items' do
    let!(:cart) { create(:cart) }
    let!(:product1) { create(:product, price: 10.0) }
    let!(:product2) { create(:product, price: 25.5) }

    let!(:cart_item1) { create(:cart_item, cart: cart, product: product1, quantity: 2, total_price: 20.0) }
    let!(:cart_item2) { create(:cart_item, cart: cart, product: product2, quantity: 1, total_price: 25.5) }

    it 'succeeds' do
      expect(result).to be_a_success
    end

    it 'updates the cart total_price with the correct sum' do
      expect { result }.to change { cart.reload.total_price }.to(45.5)
    end

    it 'promises the updated cart' do
      expect(result.cart).to eq(cart)
      expect(result.cart.total_price).to eq(45.5)
    end
  end

  context 'when the cart is empty' do
    let!(:cart) { create(:cart, total_price: 100.0) }

    it 'succeeds and updates the cart total_price to zero' do
      expect { result }.to change { cart.reload.total_price }.from(100.0).to(0.0)
      expect(result).to be_a_success
    end
  end

  context 'when saving the cart fails' do
    let!(:cart) { create(:cart) }

    before do
      allow(cart).to receive(:save).and_return(false)
    end

    it 'fails with an error message and code' do
      expect(result).to be_a_failure
      expect(result.message).to eq('Could not save cart with total price')
      expect(result.error_code).to eq(:unprocessable_entity)
    end

    it 'does not change the cart total_price' do
      expect { result }.not_to(change { cart.reload.total_price })
    end
  end
end