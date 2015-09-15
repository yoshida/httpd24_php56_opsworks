name        "deploy"
description "Deploy applications"
maintainer  "Opsworks"
license     "Apache 2.0"
version     "1.0.0"

depends "dependencies"
depends "scm_helper"
depends "apache2"
depends "ssh_users"
depends "opsworks_agent_monit"
depends "php"

recipe "deploy::php", "Deploy a PHP application"
