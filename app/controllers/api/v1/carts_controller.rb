class CartsController < ApplicationController
  def create
    @cart = Cart.create!(cart_params)

    render json: @cart, status: :created, location: @cart
  end

  private

  def cart_params
    params.require(:cart).permit(:id)
  end
end
