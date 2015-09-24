#
# Cookbook Name:: deploy
# Recipe:: laravel5-migrate
#

node[:deploy].each do |app_name, deploy|

  # Execute `php artisan migrate`.
  execute "artisan migrate" do
    command <<-EOH
      php #{deploy[:deploy_to]}/current/artisan migrate
    EOH
  end

end
