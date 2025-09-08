
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindProduct, type: :action do
  subject(:result) { described_class.execute(ctx) }

  let(:params) { {} }
  let(:ctx) { { params: params } }

  context 'when a valid product_id is provided' do
    let!(:product) { create(:product) }
    let(:params) { { product_id: product.id } }

    it 'succeeds' do
      expect(result).to be_a_success
    end

    it 'promises found product' do
      expect(result.product).to eq(product)
    end
  end

  context 'when product_id is invalid' do
    let(:params) { { product_id: -999 } }

    it 'fails with not_found error' do
      expect(result).to be_a_failure
      expect(result.message).to eq('Product not found')
      expect(result.error_code).to eq(:not_found)
    end
  end
end