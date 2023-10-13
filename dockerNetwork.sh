#!/bin/bash

# Define network name and subnet
network_name="WHG3"
subnet="172.19.0.0/16"

# Define the container name prefix
container_name_prefix="mycontainer"

# Remove existing containers
docker rm -f $(docker ps -a --filter "name=$container_name_prefix" --format "{{.ID}}") 2>/dev/null

# Remove the existing network
docker network rm $network_name 2>/dev/null

# Create the Docker network
echo "Creating network $network_name with subnet $subnet"
docker network create $network_name --subnet=$subnet

# Take user input for the number of containers to create
read -p "Enter the number of containers to start: " num_containers

# Create the specified number of containers with unique names
for i in $(seq 1 $num_containers); do
  container_name="${container_name_prefix}_${i}"
  docker run -d --name $container_name --network $network_name 658ee380df1d
done
