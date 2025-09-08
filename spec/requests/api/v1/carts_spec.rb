require 'rails_helper'

RSpec.describe "Api::V1::Carts", type: :request do
  describe "POST /add_items" do
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product) }

    context 'when the product already is in the cart' do
      subject do
        post '/api/v1/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/api/v1/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end

  describe "DELETE /remove_item" do
    let!(:product) { create(:product, price: 100.0) }
    let!(:other_product) { create(:product, price: 50.0) }

    context 'when the product is in the cart' do
      before do
        post api_v1_cart_path, params: { product_id: product.id, quantity: 1 }, as: :json
        post api_v1_cart_path, params: { product_id: other_product.id, quantity: 2 }, as: :json
      end

      it 'removes the specified item from the cart and returns the updated cart' do
        expect {
          delete "/api/v1/cart/#{product.id}", as: :json
        }.to change(CartItem, :count).by(-1)

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['products'].count).to eq(1)
        expect(json_response['products'][0]['id']).to eq(other_product.id)
        expect(json_response['total_price']).to eq('100.0')
      end
    end

    context 'when the product is not in the cart' do
      before do
        post api_v1_cart_path, params: { product_id: other_product.id, quantity: 1 }, as: :json
      end

      it 'does not change the cart and returns not_found' do
        expect {
          delete "/api/v1/cart/#{product.id}", as: :json
        }.not_to change(CartItem, :count)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET show" do
    context 'when the cart is empty' do
      before do
        get '/api/v1/cart', as: :json
      end

      it 'returns an empty cart' do
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)

        expect(json_response['products']).to be_empty
        expect(json_response['total_price'].to_s).to eq('0.0')
        expect(json_response['id']).to be_a(Integer)
      end
    end

    context 'when thet cart has items' do
      let(:product) { create(:product, price: 100.0) }

      before do
        post api_v1_cart_path, params: { product_id: product.id, quantity: 2 }, as: :json
        get '/api/v1/cart', as: :json
      end

      it 'returns the cart with items' do
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)

        expect(json_response['products'].count).to eq(1)
        expect(json_response['products'][0]['id']).to eq(product.id)
        expect(json_response['products'][0]['quantity']).to eq(2)
      end
    end
  end

  describe 'POST /create' do
    let(:product) { create(:product) }
    let(:quantity) { 2 }
    let(:total_price) { product.price * quantity }

    before do
      post api_v1_cart_path, params: { product_id: product.id, quantity: quantity }, as: :json
    end

    it 'creates a new cart' do
      expect(response).to have_http_status(:created)

      json_response = JSON.parse(response.body)

      expect(json_response['products'].count).to eq(1)
      expect(json_response['products'][0]['id']).to eq(product.id)
      expect(json_response['products'][0]['quantity']).to eq(2)
      expect(json_response['total_price']).to eq(total_price.to_s)
    end
  end
end
