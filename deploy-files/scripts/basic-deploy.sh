#Script for install docker and docker-compose. Allow to deploy the app for first time if you have the docker-compose.yml and .env files.

# Add Docker's official GPG key:
sudo apt update -y
sudo apt upgrade -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

#Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

#User Permissions
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker

#Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#Create the basic configuration to deploy the app
sudo mkdir -p /opt/job
sudo chown ubuntu:ubuntu /opt/job
nano /opt/job/docker-compose.yml
nano .env

#Login in ecr
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 273354652660.dkr.ecr.us-east-1.amazonaws.com

#Download the docker image for jobberwocky
docker build . -t 273354652660.dkr.ecr.us-east-1.amazonaws.com/avanture/jobberwocky
docker push 273354652660.dkr.ecr.us-east-1.amazonaws.com/avanture/jobberwocky

#Download the docker image for jobberwocky-extra-source
docker build . -t 273354652660.dkr.ecr.us-east-1.amazonaws.com/avanture/jobberwocky-extra-source
docker push 273354652660.dkr.ecr.us-east-1.amazonaws.com/avanture/jobberwocky-extra-source