class FindSessionCart
  extend LightService::Action

  expects :cart_id
  promises :cart

  executed do |context|
    cart = Cart.find_by(id: context.cart_id)

    if cart.nil?
      context.fail!('Cart not found', error_code: :not_found)
    end

    context.cart = cart
  end
end