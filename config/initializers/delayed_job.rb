#refer https://github.com/collectiveidea/delayed_job/blob/3bb9d4f3b761c9016b558d30cda4f80e952a526a/README.md
Delayed::Worker.destroy_failed_jobs = true
Delayed::Worker.max_attempts = 2
Delayed::Worker.max_run_time = 1.hours #default 4.hours
Delayed::Worker.delay_jobs = !Rails.env.test?
# Delayed::Worker.raise_signal_exceptions = :term
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))