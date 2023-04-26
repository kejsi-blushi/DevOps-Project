#!/bin/bash

# Set the DockerHub username and Docker image name
dockerhub_username="kejsiblushi"
docker_image="project_img"

# Fetch the latest changes from the main branch
git fetch origin main

# Get the latest commit hashes of the main and master branches
main_commit=$(git rev-parse origin/main)
last_commit=$(git rev-parse HEAD)

# Compare the latest commit hashes to check for new commits
if [ "$main_commit" != "$last_commit" ]; then
   # New commit detected, trigger Docker build and deployment

  # Get the first 7 digits of the commit hash
  commit_hash=$(git log --pretty=format:'%h' -n 1)

  # Build the Docker image with the latest changes and tag it with the commit hash
  docker build -t $dockerhub_username/$docker_image:$commit_hash react-todo-app/

  # Push the Docker image to DockerHub
  docker push $dockerhub_username/$docker_image:$commit_hash

  # Deploy the new version of the Helm chart with the new Docker image
  helm upgrade  react-helm ./my_helm_chart  --set image.tag="$commit_hash"

  echo "New commit detected. Docker image built, pushed to DockerHub, and Helm chart deployed."
  

else
   # No new commit detected, exit the script
  echo "No new commit detected. Exiting."
  exit 0
 
fi
