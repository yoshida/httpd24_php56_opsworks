#
# Cookbook Name:: deploy
# Recipe:: laravel5-deploy
#

node[:deploy].each do |app_name, deploy|

  # Execute `composer install`.
  execute "composer" do
    command <<-EOH
      composer install -d #{deploy[:deploy_to]}/current
    EOH
  end

  # Copy the ".env.example" file to ".env" file.
  file "#{deploy[:deploy_to]}/current/.env" do
    content lazy { IO.read("#{deploy[:deploy_to]}/current/.env.example") }
    group deploy[:group]
    owner deploy[:user]
  end
  
  # Copy the ".env.example" to ".env", and edit environment configration from 'Stack Custom JSON' setting.
  file "#{deploy[:deploy_to]}/current/.env" do
    group deploy[:group]
    owner deploy[:user]
    content lazy {
      dotenv = Chef::Util::FileEdit.new("#{deploy[:deploy_to]}/current/.env.example")
      node[:laravel5_deploy][:dotenv].each do |key, value|
        dotenv.search_file_replace_line(/^#{key}=.*$/, "#{key}=#{value}\n")
      end
      dotenv.send(:contents).join
    }
  end

  # Add write-access permission to "storage" directory.
  directory "#{deploy[:deploy_to]}/current/storage" do
    group deploy[:group]
    owner deploy[:user]
    mode 0777
    action :create
    recursive true
  end

  # Add write-access permission to "bootstrap/cache" directory.
  directory "#{deploy[:deploy_to]}/current/bootstrap/cache" do
    group deploy[:group]
    owner deploy[:user]
    mode 0777
    action :create
    recursive true
  end

  # Execute `php artisan migrate`.
  execute "artisan migrate" do
    command <<-EOH
      php #{deploy[:deploy_to]}/current/artisan migrate
    EOH
  end

end
