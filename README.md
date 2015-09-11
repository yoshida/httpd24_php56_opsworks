Note: recipes in this repository is unstable yet...

# httpd24_php56_opsworks

Stack Custom JSON


    {
      "apache": {
        "package": "httpd24",
        "service_name": "httpd",
        "version": "2.4",
        "lock_dir": "/var/run/httpd",
        "keepalive": "On",
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
        ]
      },
      "mysql":{
        "version":"5.6",
        "port":"3306",
        "server_root_password":"",
        "remove_anonymous_users":true,
        "remove_test_database":true
      }
    }

