#
# Cookbook Name:: deploy
# Recipe:: laravel5-deploy
#

node[:deploy].each do |app_name, deploy|

  execute "composer" do
    command <<-EOH
      composer install -d #{deploy[:deploy_to]}/current
    EOH
  end

  file "#{deploy[:deploy_to]}/current/.env" do
    content IO.read("#{deploy[:deploy_to]}/current/.env.example")
  end

  directory "#{deploy[:deploy_to]}/current/storage" do
    group deploy[:group]
    owner deploy[:user]
    mode 0777
    action :create
    recursive true
  end

  directory "#{deploy[:deploy_to]}/current/bootstrap/cache" do
    group deploy[:group]
    owner deploy[:user]
    mode 0777
    action :create
    recursive true
  end

  execute "artisan migrate" do
    command <<-EOH
      php artisan migrate
    EOH
  end

end
