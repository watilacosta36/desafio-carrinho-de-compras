class FindSessionCart
  extend LightService::Action

  expects :session
  promises :cart

  executed do |context|
    cart = Cart.find_by(id: context.session[:cart_id])

    if cart.nil?
      context.fail!('Cart not found', status: :not_found)
    end

    context.cart = cart
  end
end