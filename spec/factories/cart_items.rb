FactoryBot.define do
  factory :cart_item do
    cart factory: :cart
    product factory: :product

    quantity { 1 }
    total_price { 100.0 }
  end
end