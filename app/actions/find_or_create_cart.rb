class FindOrCreateCart
  extend ::LightService::Action

  expects :session
  promises :cart

  executed do |context|
    cart_id = context.session[:cart_id]
    cart = Cart.find_by(id: cart_id)

    if cart.nil?
      cart = Cart.create(total_price: 0)
      context.session[:cart_id] = cart.id
    end

    context.cart = cart
  end
end
