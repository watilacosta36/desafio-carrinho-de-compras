class FindCart
  extend LightService::Action

  expects :session, :params
  promises :cart

  executed do |context|
    product_id = context.params[:product_id]
    cart_id    = (context.session[:cart_id] || CartItem.find_by(product_id: product_id)&.cart&.id)

    cart = Cart.find_by(id: cart_id)

    if cart.nil?
      context.fail!('Cart not found', error_code: :not_found)
    end

    context.cart = cart
  end
end