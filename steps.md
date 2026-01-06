Azure VM - Linux - UBUNTU | NSG - 5000 

sudo apt install git 
sudo apt install docker.io 
sudo systemctl statr docker 
sudo systemctl enable docker

sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

docker --version 
sudo systemctl status docker 
docker compose version 



git clone https://github.com/atulkamble/docker-compose-flask-mysql.git
cd docker-compose-flask-mysql

docker running // docker desktop 

sudo sytemctl status docker 

cd app 

docker compose up -d 

docker compose down 

http://localhost:5000 

docker exec -it mysql_db mysql -uroot -proot123 -D flaskdb -e "SELECT * FROM entries;
