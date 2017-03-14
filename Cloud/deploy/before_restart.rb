rails_env = new_resource.environment['RAILS_ENV']

Chef::Log.info("Mapping the environment_variables node for RAILS_ENV=#{rails_env}...")
node[:deploy].each do |_application, deploy|
  deploy[:environment_variables].each do |key, value|
    ENV[key] = value
  end
end
