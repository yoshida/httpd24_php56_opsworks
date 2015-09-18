AWS OpsWorks custom layer with support for PHP 5.6 and php application deployment.

# httpd24_php56_opsworks

AWS OpsWorks custom layer with support for PHP 5.6 and Apache 2.4 and php application deployment.

## Initial Stack Setup

1. Add a new stack
2. Under Advanced Settings:
   - Pick chef version `11.10` as the chef version
   - Use custom cookbook pointing to `https://github.com/yoshida/httpd24_php56_opsworks.git` (or fork this repo and host it yourself)
   - Enable "Manage Berkshelf" with `3.2.0` as the version
   - Add Custom JSON:

```
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
   }
 }
```

3. Add a new `App Server -> Custom Layer` layer. (Note: that only Amazon Linux AMI is supported.)
4. Edit the newly created layer, and add the custom recipes:
  * Setup: apache2 php composer apache2::mod_php5
  * Deploy: deploy::php-deploy
5. Add a PHP application from the "Applications" section

