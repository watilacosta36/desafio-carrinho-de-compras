# frozen_string_literal: true

class ListCartItemsOrganizer
  extend LightService::Organizer

  def self.call(session)
    with(
      session: session,
    ).reduce(
      FindOrCreateCart,
      BuildCartPayload
    )
  end
end