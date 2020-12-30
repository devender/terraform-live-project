* cd to this dir
* ./gradlew
* Docker ` docker build -t sample-app .`

Docker to ECR Setup
* `aws ecr get-login-password --region us-west-2 --profile devender-personal | docker login --username AWS --password-stdin 324671914464.dkr.ecr.us-west-2.amazonaws.com`
* `docker tag sample-app:latest 324671914464.dkr.ecr.us-west-2.amazonaws.com/microservice-sample-ecr:latest`
* `docker push 324671914464.dkr.ecr.us-west-2.amazonaws.com/microservice-sample-ecr:latest`