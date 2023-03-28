# test-aws-ecs-cluster
Creating ECS cluster using terraform and deploying the node js app from container image
================================================
First checked through the DockerFile by running it locally where docker is installed via Docker Desktop
run through the following commands
  - docker build -t sample-image .

# once the image is created, validated the image and then have run through the docker image and validated its status
- docker run -p 3000:3000 sample-image

validated it using http://localhost:3000/ as well

Have run through the Terraform files to setup of the infrastructure (VPC, subnets, IGW, ECS cluster) using sample.tfvars -> passing the variables externally

aws ecr --region us-east-1 | docker login -u AWS -p <key> <ECR-repo-URI>

- docker tag sample-image 01234567890.dkr.ecr.us-east-1.amazonaws.com/sample-ecr-repo
- docker push 01234567890.dkr.ecr.us-east-1.amazonaws.com/sample-ecr-repo

Docker Image was uploaded into ECR making sure that the ECR is able to accept the images. And as well the relevant IAM roles available for ECR and ECS cluster.

Validated relevant services created and tasks as well

