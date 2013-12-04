#!/usr/bin/env ruby
require File.expand_path('../../config/application', __FILE__)
Rails.application.require_environment!

class ResqueWorkerDaemon < DaemonSpawn::Base
  def start(args)
    @worker = Resque::Worker.new('default')
    @worker.verbose = true
    @worker.work
  end

  def stop
  end
end

ResqueWorkerDaemon.spawn!({
  :processes => 1,
  :working_dir => Rails.root,
  :pid_file => File.join(Rails.root, 'tmp', 'pids', 'resque_worker.pid'),
  :log_file => File.join(Rails.root, 'log', 'resque_worker.log'),
  :sync_log => true,
  :singleton => true,
  :signal => 'QUIT'
})
