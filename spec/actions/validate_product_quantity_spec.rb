# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ValidateProductQuantity, type: :action do
  subject(:result) { described_class.execute(ctx) }

  let(:params) { {} }
  let(:ctx) { { params: params } }

  context 'with valid product_id and quantity' do
    let!(:product) { create(:product) }
    let(:params) { { product_id: product.id, quantity: 2 } }

    it 'succeeds' do
      expect(result).to be_a_success
    end

    it 'promises the found product' do
      expect(result.product).to eq(product)
    end

    it 'promises the integer quantity' do
      expect(result.quantity).to eq(2)
    end
  end

  context 'when product is not found' do
    let(:params) { { product_id: -999, quantity: 1 } }

    it 'fails with a not_found error' do
      expect(result).to be_a_failure
      expect(result.message).to eq('Product not found')
      expect(result.error_code).to eq(:not_found)
    end
  end

  context 'when quantity is zero' do
    let!(:product) { create(:product) }
    let(:params) { { product_id: product.id, quantity: 0 } }

    it 'fails with an unprocessable_entity error' do
      expect(result).to be_a_failure
      expect(result.message).to eq('Quantity must be a positive integer.')
      expect(result.error_code).to eq(:unprocessable_entity)
    end
  end

  context 'when product_id is missing' do
    let(:params) { { quantity: 1 } }

    it 'fails with a bad_request error' do
      expect(result).to be_a_failure
      expect(result.message).to eq('Product not found')
      expect(result.error_code).to eq(:not_found)
    end
  end
end