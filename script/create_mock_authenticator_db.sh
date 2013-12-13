echo "
CREATE DATABASE /*!32312 IF NOT EXISTS*/ \`test_auth_db\` /*!40100 DEFAULT CHARACTER SET utf8 */;

GRANT ALL ON test_auth_db.* TO 'rubycas'@'%';

USE \`test_auth_db\`;

DROP TABLE IF EXISTS \`users\`;

CREATE TABLE \`users\` (
  \`id\` int(11) NOT NULL AUTO_INCREMENT,
  \`login\` varchar(255) NOT NULL,
  \`email\` varchar(255) NOT NULL,
  \`crypted_password\` varchar(255) NOT NULL,
  \`password_salt\` varchar(255) NOT NULL,
  \`persistence_token\` varchar(255) NOT NULL,
  \`login_count\` int(11) NOT NULL DEFAULT '0',
  \`failed_login_count\` int(11) NOT NULL DEFAULT '0',
  \`last_request_at\` datetime DEFAULT NULL,
  \`current_login_at\` datetime DEFAULT NULL,
  \`last_login_at\` datetime DEFAULT NULL,
  \`current_login_ip\` varchar(255) DEFAULT NULL,
  \`last_login_ip\` varchar(255) DEFAULT NULL,
  \`created_at\` datetime DEFAULT NULL,
  \`updated_at\` datetime DEFAULT NULL,
  PRIMARY KEY (\`id\`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8" \
  | mysql -u 'root' --password='rootpass'
