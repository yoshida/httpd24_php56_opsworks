#
# Cookbook Name:: deploy
# Recipe:: laravel5-deploy
#

node[:deploy].each do |app_name, deploy|

  # Execute `composer install`.
  execute "composer" do
    command <<-EOH
      composer install -d #{deploy[:deploy_to]}/current --no-dev --optimize-autoloader
    EOH
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
  execute "Add write-access permission to storage directory" do
    command "chmod -R 777 #{deploy[:deploy_to]}/current/storage"
  end

  # Add write-access permission to "bootstrap/cache" directory.
  execute "Add write-access permission to bootstrap/cache directory" do
    command "chmod -R 777 #{deploy[:deploy_to]}/current/bootstrap/cache"
  end
  
  # Delete <root>/storage/logs and create symlink <root>/storage/logs pointing to <root>/log
  directory "#{deploy[:deploy_to]}/current/storage/logs" do
    action :delete
    recursive true
  end
  link "#{deploy[:deploy_to]}/current/storage/logs" do
    group deploy[:group]
    owner deploy[:user]
    to "#{deploy[:deploy_to]}/current/log"
  end

end
