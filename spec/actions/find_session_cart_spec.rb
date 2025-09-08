# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindSessionCart, type: :action do
  subject(:result) { described_class.execute(ctx) }

  context 'when a valid cart_id is provided' do
    let!(:cart) { create(:cart) }
    let(:ctx) { { cart_id: cart.id } }

    it 'succeeds' do
      expect(result).to be_a_success
    end

    it 'promises the found cart' do
      expect(result.cart).to eq(cart)
    end
  end

  context 'when the provided cart_id is invalid' do
    let(:ctx) { { cart_id: -999 } }

    it 'fails with a "Cart not found" error' do
      expect(result).to be_a_failure
      expect(result.message).to eq('Cart not found')
      expect(result.error_code).to eq(:not_found)
    end
  end

  context 'when the cart_id is nil' do
    let(:ctx) { { cart_id: nil } }

    it 'fails with a "Cart not found" error' do
      expect(result).to be_a_failure
      expect(result.message).to eq('Cart not found')
      expect(result.error_code).to eq(:not_found)
    end
  end
end