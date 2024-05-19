# frozen_string_literal: true

# Asynchronous job for running availability checks on a given service
class CheckServiceJob < ApplicationJob
  queue_as :service_checks_with_chrome

  def perform(service_id)
    service = Service.find(service_id)
    service.check
  end
  
end
