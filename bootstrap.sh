if [ ! -e .bootstrapped ] 
then
  touch .bootstrapped
  apt-get update
  apt-get install vim -y
  gem install chef --version '~> 11' --no-rdoc --no-ri --conservative
fi
