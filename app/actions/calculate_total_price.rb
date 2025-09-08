class CalculateTotalPrice
  extend LightService::Action

  expects :cart
  promises :cart

  executed do |context|
    cart = context.cart

    cart.total_price = cart.cart_items.sum { |item| item.total_price }

    unless cart.save
      context.fail!('Could not save cart with total price', error_code: :unprocessable_entity)
    end

    context.cart = cart
  end
end
