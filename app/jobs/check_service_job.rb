# frozen_string_literal: true

# Asynchronous job for running availability checks on a given service
class CheckServiceJob < ApplicationJob
  queue_as :service_checks_with_chrome

  include GoodJob::ActiveJobExtensions::Concurrency

  good_job_control_concurrency_with(
    # Maximum number of unfinished jobs to allow with the concurrency key
    # Can be an Integer or Lambda/Proc that is invoked in the context of the job
    # total_limit: 1,

    # Or, if more control is needed:
    # Maximum number of jobs with the concurrency key to be
    # concurrently enqueued (excludes performing jobs)
    # Can be an Integer or Lambda/Proc that is invoked in the context of the job
    enqueue_limit: 1,

    # Maximum number of jobs with the concurrency key to be
    # concurrently performed (excludes enqueued jobs)
    # Can be an Integer or Lambda/Proc that is invoked in the context of the job
    # perform_limit: 1,

    # Maximum number of jobs with the concurrency key to be enqueued within
    # the time period, looking backwards from the current time. Must be an array
    # with two elements: the number of jobs and the time period.
    # enqueue_throttle: [1, 1.minute],

    # Maximum number of jobs with the concurrency key to be performed within
    # the time period, looking backwards from the current time. Must be an array
    # with two elements: the number of jobs and the time period.
    # perform_throttle: [60, 1.hour],

    key: -> { "#{queue_name}-service-#{arguments[0]}" }

  )

  def perform(service_id)
    service = Service.find(service_id)
    service.check
  end
  
end
