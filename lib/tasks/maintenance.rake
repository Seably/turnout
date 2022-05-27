require 'turnout'

namespace :maintenance do
  desc 'Enable the maintenance mode page ("reason", "allowed_paths", "allowed_ips" and "response_code" can be passed as environment variables)'
  rule /\Amaintenance:(.*:|)start\Z/ do |task|
    invoke_environment

    maint_settings = Turnout::Settings.storage_class.new
    maint_settings.import_env_vars(ENV)
    maint_settings.write

    puts "Started maintenance mode"
    puts "Run `rake #{task.name.gsub(/\:start/, ':end')}` to stop maintenance mode"
  end

  desc 'Disable the maintenance mode page'
  rule /\Amaintenance:(.*:|)end\Z/ do |task|
    invoke_environment

    maint_file = maintenance_file_for(task)

    if maint_file.delete
      puts "Stopped maintenance mode"
    else
      fail 'Could not find a maintenance file to delete'
    end
  end

  def invoke_environment
    if Rake::Task.task_defined? 'environment'
      Rake::Task['environment'].invoke
    end
  end
end
