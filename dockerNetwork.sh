#!/bin/bash


network_name="WHG3"
subnet="10.116.0.0/24"


container_name_prefix="mycontainer"


docker rm -f $(docker ps -a --filter "name=$container_name_prefix" --format "{{.ID}}") 2>/dev/null


docker network rm $network_name 2>/dev/null


echo "Creating network $network_name with subnet $subnet"
docker network create $network_name --subnet=$subnet


read -p "Enter the Docker Hub container image (e.g., username/repo:tag): " docker_image


read -p "Enter the number of containers to start: " num_containers


for i in $(seq 1 $num_containers); do
  container_name="${container_name_prefix}_${i}"
  container_id=$(docker run -d --name $container_name --network $network_name $docker_image)
  

  container_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container_id)

  echo "Container ID: $container_id, IP Address: $container_ip"
done
