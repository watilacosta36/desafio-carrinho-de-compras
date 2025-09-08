# frozen_string_literal: true

class AddCartItemOrganizer
  extend LightService::Organizer

  def self.call(params, session)
    with(
      params: params,
      session: session
    ).reduce(
      FindCart,
      ValidateProductQuantity,
      FindOrCreateCartItem,
      CalculateTotalPrice,
      BuildCartPayload
    )
  end
end
