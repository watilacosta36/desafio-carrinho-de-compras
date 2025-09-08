class FindProduct
  extend LightService::Action

  expects :params
  promises :product

  executed do |context|
    product = Product.find_by(id: context.params[:product_id])

    if product.nil?
      context.fail!('Product not found', error_code: :not_found)
    end

    context.product = product
  end
end
