# Shut down the async job adapter on process exit so the process can terminate
# (e.g. when you Ctrl-C the dev server). Otherwise the adapter's thread pool
# can keep the process alive.
if Rails.env.development?
  at_exit do
    adapter = ActiveJob::Base.queue_adapter
    if adapter.respond_to?(:shutdown)
      adapter.shutdown(wait: false)
    end
  end
end
