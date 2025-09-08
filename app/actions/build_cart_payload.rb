class BuildCartPayload
  extend LightService::Action

  expects :cart
  promises :payload

  executed do |context|
    cart = context.cart

    response_payload = {
      id: cart.id,
      products: cart.cart_items.includes(:product).map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.price,
          total_price: item.total_price
        }
      end,
      total_price: cart.total_price
    }

    context.payload = response_payload
  end
end