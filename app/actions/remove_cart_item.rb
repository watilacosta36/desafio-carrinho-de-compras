class RemoveCartItem
  extend LightService::Action

  expects :product, :cart
  promises :cart

  executed do |context|
    cart      = context.cart
    product   = context.product
    cart_item = cart.cart_items.find_by(product_id: product.id)

    context.fail_and_return!('Item not found in cart', error_code: :not_found) unless cart_item

    if cart_item.quantity > 1
      cart_item.quantity -= 1
      cart_item.total_price = cart_item.product.price * cart_item.quantity

      context.fail!('Could not remove cart item', error_code: :unprocessable_entity) unless cart_item.save
    else
      cart_item.destroy!
    end

    context.cart = cart
  end
end
