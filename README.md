#Project 6
##Kubernetes + Simplified Networking and Storage
![alt tag](https://cloud.githubusercontent.com/assets/3618819/8199045/1a612582-1464-11e5-96ca-69ed66a399ab.png)

##About
Project 6 is software for deploying and managing Docker containers across a cluster of hosts, with a focus on simplifying network and storage configurations for on-premises environments. It builds on Google's <a href="http://kubernetes.io" target="_blank">Kubernetes</a>, <a href="http://docker.io" target="_blank">Docker</a> and CoreOS's <a href="https://github.com/coreos/etcd" target="_blank">Etcd</a>. Get your Kubernetes cluster up and running in just 3 simple steps in less than 10 minutes.

##Setup

Install <a href="https://www.vagrantup.com" target="_blank">Vagrant</a> and 
<a href="https://www.virtualbox.org/wiki/Downloads" target="_blank">VirtualBox</a>


##Quick start guide

Clone the repository and bring up the VMs.
```
$ git clone https://github.com/DatawiseIO/Project6.git
$ cd Project6/vagrant
$ vagrant up
```
By default 3 VMs with 1G RAM & 2 CPU cores are created. Each VM is assigned a
192.168.30.x IP address. Datawise.io software is already installed in these VMs.
dwctl is the command line tool to interact with the cluster. Every dwctl command
has help available with the -h option.

Here are the three simple steps to create a cluster, provision a network and
start nginx/mysql.

####Step 1 - Create a cluster
```
$ vagrant ssh node-1

$ dwctl cluster create mycluster 192.168.30.11,192.168.30.12,192.168.30.13 \
--vip 192.168.30.10 --poddns mycluster.datawise.io
```

Check cluster status
```
$ dwctl cluster status
```
####Step 2 - Create a network
This network is used to assign IP addresses to pods.
```
$ dwctl network create blue -s 192.168.30.0/24 --start 192.168.30.101 \
--end 192.168.30.200 -g 192.168.30.1
```
####Step 3 - Create a stateless or stateful pod

#####Stateless example - nginx
```
$ dwctl pod create nginx -i docker.io/nginx:latest -n blue
```

Get status of the pod.

```
[root@node-1 ~]# dwctl pod get nginx
POD           IP             CONTAINER(S)   IMAGE(S)                HOST          LABELS    STATUS    CREATED
nginx         192.168.30.106 nginx          docker.io/nginx:latest  192.168.30.12 <none>    Running   10 seconds   
```

Connect to nginx using the url http://192.168.30.106 

#####Stateful example - mysql
```
dwctl volume create wp-vol -v vol1,1G,ext4

dwctl pod create mysql -i docker.io/mysql:latest \
-v wp-vol/vol1:/var/lib/mysql,rw -n blue -c 1250 -m 750M \
-e MYSQL_ROOT_PASSWORD=root
```

###Advanced use cases
Please refer to the docs and examples directories for more details on these use cases.
* Multi tier applications ([wordpress & mysql](https://github.com/DatawiseIO/Project6/blob/master/examples/wordpress-mysql.sh))
* Clustered applications (like [zookeeper](https://github.com/DatawiseIO/Project6/tree/master/examples/zookeeper), [cassandra](https://github.com/DatawiseIO/Project6/tree/master/examples/cassandra))
* [Multi instance pods](https://github.com/DatawiseIO/Project6/blob/master/docs/replicators.md)

##Features
###Cluster management
* Single command to set up a kubernetes cluster
* Easy to grow/shrink the cluster
* Self healing control plane with no single point of failure
* Process management through systemd
* Virtual IP for stable API endpoint access
* NTP for cluster wide time synchronization
* DNS server provisioning for external connectivity
* MDNS based discovery of free nodes
* Built in DNS server for pods
* Integrated logging & monitoring services
* Command line tool and REST interfaces

###Docker container management
####Kubernetes features
* Pods
* Replication controllers
* Labels
* Events
* CPU, memory, constraint scheduler
* cadvisor, heapster for statistics
* Cluster DNS server for inter pod connectivity

####Datawise extensions
* Direct attached storage scheduling & provisioning
* Durable & temporary storage
* Cluster wide network resource management (IPs & MACs)
* [Anti affinity scheduler](https://github.com/GoogleCloudPlatform/kubernetes/pull/9560)
* Agent container per node

##Roadmap
This is a preliminary implementation (version 0.1), based on Docker (version 1.5.0) and Google’s Kubernetes (version 0.16), with plans to stay current with the new releases and make open source contributions back to those projects.  Based on community input, we will add more enterprise grade network and storage features over time, and also extend compatibility to other orchestration layers such as Docker Swarm and Apache Mesos.

##Feedback & Support
Your feedback, suggestions and questions are very important to us.  Please let us know what you think via our discussion forum datawiseio-project6@googlegroups.com or by email project6@datawise.io.

A Vagrant and VirtualBox configuration is available via the Setup steps above for quick download and evaluation.  If you would like to install the software in a different environment, or bare-metal servers please get in touch and we would be happy to help.

Disclaimer: this is an alpha/preview release.  We are happy to answer questions and provide help on a best effort basis, but would not recommend production usage yet.
