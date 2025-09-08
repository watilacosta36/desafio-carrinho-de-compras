class FindOrCreateCartItem
  extend LightService::Action

  expects :product, :quantity, :cart
  promises :cart_item

  executed do |context|
    cart     = context.cart
    product  = context.product
    quantity = context.quantity

    cart_item = cart.cart_items.find_by(product_id: product.id)

    if cart_item
      cart_item.quantity += quantity
      cart_item.total_price = product.price * cart_item.quantity
    else
      cart_item = cart.cart_items.build(
        product: product,
        quantity: quantity,
        total_price: product.price * quantity
      )
    end

    unless cart_item.save
      context.fail!('Could not save cart item', error_code: :unprocessable_entity)
    end

    context.cart_item = cart_item
  end
end
