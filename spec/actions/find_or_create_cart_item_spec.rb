# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindOrCreateCartItem, type: :action do
  subject(:result) { described_class.execute(ctx) }

  let!(:cart) { create(:cart) }
  let!(:product) { create(:product, price: 50.0) }
  let(:quantity) { 2 }
  let(:ctx) { { cart: cart, product: product, quantity: quantity } }

  context 'when adding a new product to the cart' do
    it 'succeeds' do
      expect(result).to be_a_success
    end

    it 'creates a new cart item' do
      expect { result }.to change(CartItem, :count).by(1)
    end

    it 'promises a new cart_item with correct attributes' do
      new_item = result.cart_item
      expect(new_item).to be_a(CartItem)
      expect(new_item).to be_persisted
      expect(new_item.cart).to eq(cart)
      expect(new_item.product).to eq(product)
      expect(new_item.quantity).to eq(2)
      expect(new_item.total_price).to eq(100.0)
    end
  end

  context 'when adding more of an existing product to the cart' do
    let!(:existing_item) do
      create(:cart_item, cart: cart, product: product, quantity: 1, total_price: 50.0)
    end
    let(:quantity) { 3 }

    it 'succeeds' do
      expect(result).to be_a_success
    end

    it 'does not create a new cart item' do
      expect { result }.not_to change(CartItem, :count)
    end

    it 'updates the quantity and total_price of the existing item' do
      expect { result }.to change { existing_item.reload.quantity }
                             .from(1).to(4).and change { existing_item.reload.total_price }.from(50.0).to(200.0)
    end

    it 'promises the updated cart_item' do
      expect(result.cart_item).to eq(existing_item)
    end
  end

  context 'when saving the cart item fails' do
    before do
      allow_any_instance_of(CartItem).to receive(:save).and_return(false)
    end

    it 'fails' do
      expect(result).to be_a_failure
    end

    it 'returns an error message and code' do
      expect(result.message).to eq('Could not save cart item')
      expect(result.error_code).to eq(:unprocessable_entity)
    end
  end
end