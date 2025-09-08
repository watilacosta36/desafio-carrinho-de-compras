class FindOrInitializeCart
  extend ::LightService::Action

  expects :session
  promises :cart

  executed do |context|
    cart_id = context.session[:cart_id]
    cart = Cart.find_by(id: cart_id)

    if cart.nil?
      cart = Cart.create_with(total_price: 0)
      context.session[:cart_id] = cart.id
    end

    context.cart = cart
  end
end
