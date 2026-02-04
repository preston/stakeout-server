require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Stakeout
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Use the good_job gem for background jobs. https://github.com/bensheldon/good_job
    config.active_job.queue_adapter = :good_job
    # Run jobs serially by default.
    config.good_job.max_threads = 1
    config.good_job.poll_interval = 5 # seconds
    # config.good_job.preserve_job_records = true
    config.good_job.cleanup_preserved_jobs_before_seconds_ago = 600
    # config.good_job.cleanup_interval_jobs = 1_000 # Number of executed jobs between deletion sweeps.
    config.good_job.cleanup_interval_seconds = 1.minute # Number of seconds between deletion sweeps.

  end
end
