#!/bin/bash

# Function to build and push Docker images
build_and_push() {
  local dockerfile=$1
  local image_tag=$2

  echo "Building image from $dockerfile and tagging as $image_tag"
  sudo docker build -f "$dockerfile" -t "$image_tag" .
  if [ $? -ne 0 ]; then
    echo "Failed to build $image_tag"
    exit 1
  fi

  echo "Pushing image $image_tag"
  sudo docker push "$image_tag"
  if [ $? -ne 0 ]; then
    echo "Failed to push $image_tag"
    exit 1
  fi
}

# Function to prompt for input if not provided
prompt_for_input() {
  local var_name=$1
  local prompt_message=$2
  local input_value=${!var_name}

  if [ -z "$input_value" ]; then
    read -p "$prompt_message: " input_value
    export $var_name=$input_value
  fi
}

# Check if the necessary arguments are provided
if [ $# -lt 2 ]; then
  echo "Usage: $0 <region> <aws_region>"
  exit 1
fi

# Set the region and AWS region from the arguments
region=$1
aws_region=$2

# Define the Docker images and their corresponding Dockerfiles
declare -A images=(
  ["squid"]="109836227571.dkr.ecr.${aws_region}.amazonaws.com/${region}-squid:v0"
  ["proxy"]="109836227571.dkr.ecr.${aws_region}.amazonaws.com/${region}-proxy:v0"
  ["parseserver"]="109836227571.dkr.ecr.${aws_region}.amazonaws.com/${region}-parseserver:v0"
  ["auth"]="109836227571.dkr.ecr.${aws_region}.amazonaws.com/${region}-auth:v0"
  ["adminserver"]="109836227571.dkr.ecr.${aws_region}.amazonaws.com/${region}-adminserver:v0"
)

# First set of builds and pushes
build_and_push "squid.Dockerfile" "${images["squid"]}"
build_and_push "goproxy.Dockerfile" "${images["proxy"]}"
build_and_push "parseserver.Dockerfile" "${images["parseserver"]}"



# Prune the Docker system
echo "Pruning Docker system"
sudo docker system prune -a --volumes -f
if [ $? -ne 0 ]; then
  echo "Failed to prune Docker system"
  exit 1
fi

# Second set of builds and pushes
build_and_push "auth.Dockerfile" "${images["auth"]}"
build_and_push "adminserver.Dockerfile" "${images["adminserver"]}"

# Final prune
echo "Pruning Docker system"
sudo docker system prune -a --volumes -f
if [ $? -ne 0 ]; then
  echo "Failed to prune Docker system"
  exit 1
fi

echo "All operations completed successfully."
