# docker-zookeeper-cluster
Docker image for the zookeeper cluster.

Sample docker engine run for the zookeeper:

Change the parameters to suit your needs. $ID means the number of the node (either 1,2,3 etc)

docker run -d --restart=always \
      -p 2181:2181 \
      -p 2888:2888 \
      -p 3888:3888 \
      -v /var/lib/zookeeper:/var/lib/zookeeper \
      -v /var/log/zookeeper:/var/log/zookeeper  \
      <image_name> zk1,zk2,zk3 $ID

Sample configuration for the three nodes:

Node1 (10.100.2.196)

docker run -d --restart=always \
      -p 2181:2181 \
      -p 2888:2888 \
      -p 3888:3888 \
      -v /var/lib/zookeeper:/var/lib/zookeeper \
      -v /var/log/zookeeper:/var/log/zookeeper  \
      <image_name> 10.100.2.196,10.100.2.71,10.100.2.72 1

Node2 (10.100.2.71)

docker run -d --restart=always \
      -p 2181:2181 \
      -p 2888:2888 \
      -p 3888:3888 \
      -v /var/lib/zookeeper:/var/lib/zookeeper \
      -v /var/log/zookeeper:/var/log/zookeeper  \
      <image_name> 10.100.2.196,10.100.2.71,10.100.2.72 2

Node3 (10.100.2.72)

docker run -d --restart=always \
      -p 2181:2181 \
      -p 2888:2888 \
      -p 3888:3888 \
      -v /var/lib/zookeeper:/var/lib/zookeeper \
      -v /var/log/zookeeper:/var/log/zookeeper  \
      customzk 10.100.2.196,10.100.2.71,10.100.2.72 3


