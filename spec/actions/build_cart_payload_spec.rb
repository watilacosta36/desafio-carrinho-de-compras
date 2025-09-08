# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BuildCartPayload, type: :action do
  subject(:result) { described_class.execute(ctx) }
  let(:ctx) { { cart: cart } }

  context 'when the cart has items' do
    let!(:product1) { create(:product, name: 'Teclado', price: 350.0) }
    let!(:product2) { create(:product, name: 'Mouse', price: 120.50) }
    let!(:cart) { create(:cart) }

    let!(:cart_item1) do
      create(:cart_item, cart: cart, product: product1, quantity: 1, total_price: 350.0)
    end
    let!(:cart_item2) do
      create(:cart_item, cart: cart, product: product2, quantity: 2, total_price: 241.0)
    end

    before do
      cart.update!(total_price: 591.0)
    end

    it 'succeeds' do
      expect(result).to be_a_success
    end

    it 'promises a payload with the correct structure and total price' do
      payload = result.payload
      expect(payload).to include(
                           id: cart.id,
                           total_price: 591.0,
                           products: be_an(Array)
                         )
    end

    it 'includes all cart items in payload' do
      products_payload = result.payload[:products]
      expect(products_payload.size).to eq(2)
    end

    it 'build correct data for each product item' do
      products_payload = result.payload[:products]
      keyboard_payload = products_payload.find { |p| p[:id] == product1.id }
      mouse_payload = products_payload.find { |p| p[:id] == product2.id }

      expect(keyboard_payload).to match(id: product1.id,
                                    name: 'Teclado',
                                    quantity: 1,
                                    unit_price: 350.0,
                                    total_price: 350.0
                                  )

      expect(mouse_payload).to match(id: product2.id,
                                 name: 'Mouse',
                                 quantity: 2,
                                 unit_price: 120.50,
                                 total_price: 241.0
                               )
    end
  end

  context 'when the cart is empty' do
    let!(:cart) { create(:cart, total_price: 0) }

    it 'succeeds and promises a payload with empty products array' do
      expect(result).to be_a_success
      expect(result.payload).to include(id: cart.id,
                                  total_price: 0.0,
                                  products: []
                                )
    end
  end
end