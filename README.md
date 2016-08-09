# docker-zookeeper-cluster
A simple docker image to create a zookeeper cluster without much pain. 

## What is this used for?
There are several zookeeper docker images for creating standalone instances of zookeeper and running them. But there are no images that help in creating a zookeeper cluster across a single host or a multi-host environment. This image will help you to achieve the same.

# Docker image
```
docker pull jeygeethan/zookeeper-cluster
```
[Docker hub link](https://hub.docker.com/r/jeygeethan/zookeeper-cluster/)

# Looking for kafka cluster?
Go here : [kafka-cluster](https://github.com/gten/docker-kafka-cluster)

# Zookeeper Cluster (multi-host)
## Manual run of the cluster

Follow these steps:

1. Figure out if you will know the IP addresses/hosts of the hosts where you will be running the zookeepers containers.
  1. **UCP/Swarm** - You can figure this out if you are using a constraint node (-e constraint:node==host_name) in your docker-compose.yml file
  2. **Disconnected hosts** - You can figure this out by defining the set of hosts where you will deploy the container
2. Start running the containers in respective hosts or compile a sample docker-compose.yml as given below

### Generic script to run the zookeeper container:

The example given below is for a three node cluster. Change the parameters to suit your needs. $ID means the id/number of the node (either 1,2,3 etc) you are currently trying to run.

```
docker run -d --restart=always \
      -p 2181:2181 \
      -p 2888:2888 \
      -p 3888:3888 \
      -v /var/lib/zookeeper:/var/lib/zookeeper \
      -v /var/log/zookeeper:/var/log/zookeeper  \
      jeygeethan/zookeeper-cluster zookeeper_1_ip_or_hostname,zookeeper_2_ip_or_hostname,zookeeper_3_ip_or_hostname $ID
```

### Sample configuration for the three nodes:

Assume the three nodes are as follows:

1. docker_host_1
2. docker_host_2
3. docker_host_3

#### For first node (docker_host_1)

```
docker run -d --restart=always \
      -p 2181:2181 \
      -p 2888:2888 \
      -p 3888:3888 \
      -v /var/lib/zookeeper:/var/lib/zookeeper \
      -v /var/log/zookeeper:/var/log/zookeeper  \
      jeygeethan/zookeeper-cluster docker_host_1,docker_host_2,docker_host_3 1
```

#### For second node (docker_host_2)

```
docker run -d --restart=always \
      -p 2181:2181 \
      -p 2888:2888 \
      -p 3888:3888 \
      -v /var/lib/zookeeper:/var/lib/zookeeper \
      -v /var/log/zookeeper:/var/log/zookeeper  \
      jeygeethan/zookeeper-cluster docker_host_1,docker_host_2,docker_host_3 2
```

#### For third node (docker_host_3)

```
docker run -d --restart=always \
      -p 2181:2181 \
      -p 2888:2888 \
      -p 3888:3888 \
      -v /var/lib/zookeeper:/var/lib/zookeeper \
      -v /var/log/zookeeper:/var/log/zookeeper  \
      jeygeethan/zookeeper-cluster docker_host_1,docker_host_2,docker_host_3 3
```

## Sample docker-compose.yml for the cluster creation

```
version: '2'
services:
  zk_1:
    image: jeygeethan/zookeeper-cluster
    container_name: zk_1
    ports:
      - '2181:2181'
      - '2888:2888'
      - '3888:3888'
    volumes:
      - /var/lib/zookeeper:/var/lib/zookeeper
      - /var/log/zookeeper:/var/log/zookeeper
    command: docker_host_1,docker_host_2,docker_host_3 1
    environment:
      - constraint:node==docker_host_1
    networks:
      - some_overlay_network
  zk_2:
    image: jeygeethan/zookeeper-cluster
    container_name: zk_2
    ports:
      - '2181:2181'
      - '2888:2888'
      - '3888:3888'
    volumes:
      - /var/lib/zookeeper:/var/lib/zookeeper
      - /var/log/zookeeper:/var/log/zookeeper
    command: docker_host_1,docker_host_2,docker_host_3 2
    environment:
      - constraint:node==docker_host_2
    networks:
      - some_overlay_network
  zk_3:
    image: jeygeethan/zookeeper-cluster
    container_name: zk_3
    ports:
      - '2181:2181'
      - '2888:2888'
      - '3888:3888'
    volumes:
      - /var/lib/zookeeper:/var/lib/zookeeper
      - /var/log/zookeeper:/var/log/zookeeper
    command: docker_host_1,docker_host_2,docker_host_3 3
    environment:
      - constraint:node==docker_host_3
    networks:
      - some_overlay_network
networks:
  some_overlay_network:
    external: true
```
