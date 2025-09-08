class ValidateProductQuantity
  extend ::LightService::Action

  expects :params
  promises :product, :quantity

  executed do |context|
    product = Product.find_by(id: context.params[:product_id])
    quantity = context.params[:quantity].to_i

    unless quantity.is_a?(Integer) && quantity > 0
      context.fail!('Quantity must be a positive integer.', error_code: :unprocessable_entity)
    end

    unless product
      context.fail!('Product not found', error_code: :not_found)
    end

    context.product = product
    context.quantity = quantity
  end
end
