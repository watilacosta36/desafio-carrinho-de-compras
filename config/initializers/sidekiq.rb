schedule_files = 'config/sidekiq.yml'

Sidekiq.configure_server do |config|
  if File.exist?(schedule_files)
    Sidekiq::Scheduler.load_schedule! schedule_files
  end
end