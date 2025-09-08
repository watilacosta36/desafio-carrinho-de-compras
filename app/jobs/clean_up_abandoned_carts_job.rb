# frozen_string_literal: true

class CleanupAbandonedCartsJob < ApplicationJob
  queue_as :default

  def perform
    Cart.mark_inactive_as_abandoned
    Cart.remove_old_abandoned
  end
end