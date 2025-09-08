# frozen_string_literal: true

class CreateCartOrganizer
  extend LightService::Organizer

  def self.call(params, session)
    with(
      params: params,
      session: session
    ).reduce(
      FindOrCreateCart,
      ValidateProductQuantity,
      FindOrCreateCartItem,
      CalculateTotalPrice,
      BuildCartPayload
    )
  end
end
