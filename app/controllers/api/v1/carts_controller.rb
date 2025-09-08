module Api
  module V1
    class CartsController < ApplicationController
      def create
        result = ::CreateCartOrganizer.call(permitted_params, session)
        session[:cart_id] = result.session[:cart_id]

        render_json(result, :created)
      end

      def show
        result = ::ListCartItemsOrganizer.call(session)

        render_json(result, :ok)
      end

      def add_item
        result = ::AddCartItemOrganizer.call(permitted_params, session)

        render_json(result, :ok)
      end

      def remove_item
        result = ::RemoveCartItemOrganizer.call(permitted_params, session)

        render_json(result, :ok)
      end

      private

      def render_json(result, success_status)
        if result.failure?
          render json: { message: result.message }, status: result.error_code || :unprocessable_entity
        else
          render json: result.payload, status: success_status
        end
      end

      def permitted_params
        params.permit(:product_id, :quantity)
      end
    end
  end
end
