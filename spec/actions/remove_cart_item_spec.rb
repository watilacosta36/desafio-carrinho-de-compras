# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemoveCartItem, type: :action do
  subject(:result) { described_class.execute(ctx) }

  let!(:cart) { create(:cart) }
  let!(:product) { create(:product, price: 25.0) }
  let(:params) { { product_id: product.id } }
  let(:ctx) { { cart: cart, product: product } }

  context 'when item quantity is greater than 1' do
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 3, total_price: 75.0) }

    it 'succeeds' do
      expect(result).to be_a_success
    end

    it 'decrements the item quantity by 1' do
      expect { result }.to change { cart_item.reload.quantity }.from(3).to(2)
    end

    it 'updates the item total_price' do
      expect { result }.to change { cart_item.reload.total_price }.from(75.0).to(50.0)
    end

    it 'does not destroy the cart item' do
      expect { result }.not_to change(CartItem, :count)
    end
  end

  context 'when item quantity is 1' do
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1, total_price: 25.0) }

    it 'succeeds' do
      expect(result).to be_a_success
    end

    it 'destroys the cart item' do
      expect { result }.to change(CartItem, :count).by(-1)
      expect(CartItem.find_by(id: cart_item.id)).to be_nil
    end
  end

  context 'when item is not found in cart' do
    let(:params) { { product_id: -999 } }

    it 'fails with a not_found error' do
      expect(result).to be_a_failure
      expect(result.message).to eq('Item not found in cart')
      expect(result.error_code).to eq(:not_found)
    end
  end

  context 'when product_id is missing' do
    let(:params) { { product_id: nil } }

    it 'fails with a bad_request error' do
      expect(result).to be_a_failure
      expect(result.message).to eq('Item not found in cart')
      expect(result.error_code).to eq(:not_found)
    end
  end
end