#
# Cookbook Name:: deploy
# Recipe:: laravel5-migrate-refresh
#

node[:deploy].each do |app_name, deploy|

  # Execute `php artisan migrate:refresh`.
  execute "artisan migrate:refresh" do
    command <<-EOH
      php #{deploy[:deploy_to]}/current/artisan migrate:refresh --seed
    EOH
  end

end
