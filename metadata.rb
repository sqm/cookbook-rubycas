name             'rubycas-server'
maintainer       'Squaremouth'
maintainer_email 'cstephan@squaremouth.com'
license          'All rights reserved'
description      'Installs/Configures rubycas-server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

depends 'database'
depends 'god'
depends 'mysql'
depends 'postgresql'
depends 'rvm'
depends 'sqm'
