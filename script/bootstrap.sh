if [ ! -e .bootstrapped ] 
then
  touch .bootstrapped
  apt-get update
  apt-get install vim -y
fi
