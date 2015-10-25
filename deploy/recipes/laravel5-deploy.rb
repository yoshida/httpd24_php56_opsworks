#
# Cookbook Name:: deploy
# Recipe:: laravel5-deploy
#

node[:deploy].each do |app_name, deploy|

  # Execute `composer install`.
  execute "composer" do
    command <<-EOH
      composer install -d #{deploy[:deploy_to]}/current --optimize-autoloader
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
      if deploy[:database]
        dotenv.search_file_replace_line(/^DB_HOST=.*$/, "DB_HOST=#{deploy[:database][:host]}:#{deploy[:database][:port]}\n")
        dotenv.search_file_replace_line(/^DB_DATABASE=.*$/, "DB_DATABASE=#{deploy[:database][:database]}\n")
        dotenv.search_file_replace_line(/^DB_USERNAME=.*$/, "DB_USERNAME=#{deploy[:database][:username]}\n")
        dotenv.search_file_replace_line(/^DB_PASSWORD=.*$/, "DB_PASSWORD=#{deploy[:database][:password]}\n")
      end
      dotenv.send(:contents).join
    }
  end

  # Add write-access permission to "shared/log" directory.
  execute "Add write-access permission to storage directory" do
    command "chmod -R 775 #{deploy[:deploy_to]}/shared/log"
  end

  # Add write-access permission to "current/storage" directory.
  execute "Add write-access permission to storage directory" do
    command "chmod -R 775 #{deploy[:deploy_to]}/current/storage"
  end

  # Add write-access permission to "current/bootstrap/cache" directory.
  execute "Add write-access permission to bootstrap/cache directory" do
    command "chmod -R 775 #{deploy[:deploy_to]}/current/bootstrap/cache"
  end
  
  # Delete <root>/storage/logs and create symlink <root>/storage/logs pointing to <root>/log
  directory "#{deploy[:deploy_to]}/current/storage/logs" do
    action :delete
    recursive true
  end
  link "#{deploy[:deploy_to]}/current/storage/logs" do
    group deploy[:group]
    owner deploy[:user]
    to "#{deploy[:deploy_to]}/shared/log"
  end

end
