# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindOrCreateCart, type: :action do
  subject(:result) { described_class.execute(ctx) }

  let(:session) { {} }
  let(:ctx) { { session: session } }

  context 'when a valid cart_id exists in session' do
    let!(:existing_cart) { create(:cart) }
    let(:session) { { cart_id: existing_cart.id } }

    it 'succeeds' do
      expect(result).to be_a_success
    end

    it 'promises the exists cart' do
      expect(result.cart).to eq(existing_cart)
    end

    it 'not create a new cart' do
      expect { result }.not_to change(Cart, :count)
    end

    it 'not change the session cart_id' do
      expect { result }.not_to(change { session[:cart_id] })
    end
  end

  context 'when cart_id not exist in the session' do
    it 'succeeds' do
      expect(result).to be_a_success
    end

    it 'creates a new cart' do
      expect { result }.to change(Cart, :count).by(1)
    end

    it 'promises the new created cart with a total_price of zero' do
      expect(result.cart).to be_a(Cart)
      expect(result.cart).to be_persisted
      expect(result.cart.total_price).to eq(0)
    end

    it 'updates the session with the new cart_id' do
      result
      expect(session[:cart_id]).to eq(Cart.last&.id)
    end
  end

  context 'when an invalid cart_id exists in the session' do
    let(:session) { { cart_id: -999 } }

    it 'succeeds by creating a new cart' do
      expect { described_class.execute(ctx) }.to change(Cart, :count).by(1)
      expect(result).to be_a_success
    end

    it 'updates the session with the new cart_id' do
      result
      expect(session[:cart_id]).not_to eq(-999)
      expect(session[:cart_id]).to eq(Cart.last&.id)
    end
  end
end