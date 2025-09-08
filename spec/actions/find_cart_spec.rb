# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindCart, type: :action do
  subject(:result) { described_class.execute(ctx) }

  let(:session) { {} }
  let(:params) { {} }
  let(:ctx) { { session: session, params: params } }

  context 'when cart_id exists in the session' do
    let!(:cart) { create(:cart) }

    context 'adn the cart exists in database' do
      let(:session) { { cart_id: cart.id } }

      it 'succeeds' do
        expect(result).to be_a_success
      end

      it 'promises the found cart' do
        expect(result.cart).to eq(cart)
      end
    end

    context 'and the cart does not exist in the database' do
      let(:session) { { cart_id: -1 } }

      it 'fails with a not_found error' do
        expect(result).to be_a_failure
        expect(result.message).to eq('Cart not found')
        expect(result.error_code).to eq(:not_found)
      end
    end
  end

  context 'when cart_id is not in the session' do
    let!(:product) { create(:product) }
    let(:params) { { product_id: product.id } }

    context 'and a cart can be found via a cart_item' do
      let!(:cart) { create(:cart) }
      let!(:cart_item) { create(:cart_item, cart: cart, product: product) }

      it 'succeeds' do
        expect(result).to be_a_success
      end

      it 'promises the found cart' do
        expect(result.cart).to eq(cart)
      end
    end

    context 'and a cart cannot be found via a cart_item' do
      it 'fails with a not_found error' do
        expect(result).to be_a_failure
        expect(result.message).to eq('Cart not found')
        expect(result.error_code).to eq(:not_found)
      end
    end
  end
end