
# httpd24_php56_opsworks

This repository is Chef Cookbooks for AWS OpsWorks Custom layer.

Support for PHP 5.6 and Apache 2.4 and PHP Application deployment.

* Note: This recipes tested on Amazon Linux version: `Amazon Linux 2015.03`

This cookbooks use `apache2` `php` `composer` recipes retrieved from Chef Supermarket via Berkshelf.

## Initial Stack Setup

1. Add a new stack
2. Under Advanced Settings:
   - Pick chef version `11.10` as the chef version
   - Use custom cookbook pointing to `https://github.com/yoshida/httpd24_php56_opsworks.git`
   - Enable "Manage Berkshelf" with `3.2.0` as the version
   - Edit "Custom JSON" (refer to [Stack Custom JSON](#stack-custom-json) section)
3. Add a new `Custom -> Custom` layer.
  * Name: `PHP5.6 App Server` (as you like)
  * Short name: `php56app` (as you like)
4. Edit the newly created layer, and add the custom recipes:
  * Setup: `apache2` `php` `apache2::mod_php5` `composer`
    * Note: `composer` is optional recipe if you want to use composer
    * Note: `prompt` is optional recipe for display stack name to Prompt String (PS1).
  * Configure: `php::configure`
  * Deploy: `deploy::php-deploy`
    * Note: `deploy::laravel5-deploy` is optional recipe for Laravel 5.1 initial configuration (`composer` required)
      * You can customize `.env` configuration with `laravel5_deploy.dotenv` object in Stack Custom JSON (The `.env` file copied from `.env.example` file, and replace `key=value` pair in `.env` file by `laravel5_deploy.dotenv` object's key-value pair).
    * Note: `deploy::laravel5-migrate`, `deploy::laravel5-migrate-refresh` are optional recipes for database migration.
      * To execute these recipes, you can manually run recipes on `Stack -> Run Command -> Execute Recipes`.
      * Learn more: http://docs.aws.amazon.com/opsworks/latest/userguide/workingcookbook-manual.html
  * Undeploy: `deploy::php-undeploy`

## Initial Apps Setup

If you want to try deployment, we have prepared a sample application that displays phpinfo.

1. Add a new application from the "Apps" section
2. Under Settings:
   - Name: `phpinfo`
   - Type: `PHP`
   - Document root: `public`
   - Data source type: `None`
   - Repository URL: `https://github.com/yoshida/phpinfo.git`
3. Deploy `phpinfo` application 
4. Open http://[your-server]/phpinfo.php

## Stack Custom JSON

```javascript
{
  "apache": {
    "package": "httpd24",
    "service_name": "httpd",
    "version": "2.4",
    "lock_dir": "/var/run/httpd",
    "default_site_enabled": false,
    "listen_addresses": ["*"],
    "listen_ports": ["80"]
  },
  "php": {
    "packages": [
      "php56",
      "php56-devel",
      "php56-mcrypt",
      "php56-mbstring",
      "php56-gd",
      "php56-bcmath",
      "php56-pdo",
      "php56-mysqlnd",
      "php56-pecl-memcached",
      "php56-pecl-apcu",
      "php56-opcache"
    ],
    "directives": {
      "error_log": "/var/log/httpd/php_errors.log"
    }
  },
  "laravel5_deploy": {
    "dotenv": {
      "APP_ENV": "production",
      "APP_DEBUG": false
    }
  }
}
```
