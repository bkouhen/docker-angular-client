# install AWS SDK
pip install --user awscli
export PATH=$PATH:$HOME/.local/bin

# install necessary dependency for ecs-deploy
add-apt-repository ppa:eugenesan/ppa
apt-get update
apt-get install jq -y

# install ecs-deploy
curl https://raw.githubusercontent.com/silinternational/ecs-deploy/master/ecs-deploy | \
  sudo tee -a /usr/bin/ecs-deploy
sudo chmod +x /usr/bin/ecs-deploy

# login AWS ECR
# eval $(aws ecr get-login --region eu-west-3)

# or login DockerHub
echo "$DOCKER_PWD" | docker login -u "$DOCKER_ID" --password-stdin

# build the docker image and push to an image repository
docker build -t bkouhen/docker-angular-client .
docker push bkouhen/docker-angular-client:latest

# update an AWS ECS service with the new image
ecs-deploy -c $CLUSTER_NAME -n $SERVICE_NAME -r eu-west-3 -i bkouhen/docker-angular-client:latest
