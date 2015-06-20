#Clustering Guide

##Creating a cluster
A cluster is created by logging in to a node and adding other nodes to the cluster.
```
$ vagrant ssh node-1

$ dwctl cluster create mycluster 192.168.30.11,192.168.30.12,192.168.30.13 \
--vip 192.168.30.10 --poddns mycluster.datawise.io
```

##Checking the status of the cluster
```
$ dwctl cluster status
Name           	: mycluster
Id             	: 6643793367141168237
Version        	: 0.1
Master         	: 192.168.30.11
Virtual IP     	: 192.168.30.10
NTP server(s)  	: [pool.ntp.org]
DNS server(s)  	: [8.8.8.8]
Logging service	: enabled
Pod DNS Domain	: mycluster.datawise.io

IP ADDRESS      STATE     CONDITION   MILLICORES   MEMORY     STORAGE   VNICS     LABELS
192.168.30.11   Joined    Ready       0/2000       0/993.5M   0/10G     0/64      <none>
192.168.30.12   Joined    Ready       0/2000       0/993.5M   0/10G     0/64      <none>
192.168.30.13   Joined    Ready       0/2000       0/993.5M   0/10G     0/64      <none>
```

There is an election to determine which of these nodes runs the scheduler and API
end points. In the above example, ```192.168.30.11``` is the master. The cluster is
always reachable using the virtual IP of ```192.168.30.10``` from this point onwards.
dwctl commands could be run on any node by setting the environment variable VIRTUAL_IP

```
$ export VIRTUAL_IP=192.168.30.10
```

State indicates whether the node successfully joined the cluster. Ready condition
indicates the node is ready to accept workloads and is in healthy state. Resource
capacity and utilization for all nodes are listed in the next columns.

##Removing a node from the cluster

```
$ dwctl cluster remove 192.168.30.13
```

Check cluster status to ensure it was removed. Since the cluster has only three nodes,
only one node can be removed from the cluster to ensure quorum is not lost.

##Adding a node to the cluster

```
$ dwctl cluster add 192.168.30.13
```

##Change cluster configuration

```
$ dwctl cluster configure --ntp time.ubuntu.com
```

##High availability
The cluster can tolerate node, master, pod failures.

###Node failure
No new pods are scheduled to the failed node. Existing pods are relocated to other
nodes(after a timeout) unless they have hard constraints (like persistent volumes)
that prevent them from being moved.

Note: The volume portability restriction will go away in the future.

###Master failure
A new node is elected to be the master and hosts the Virtual IP for the cluster.
Cluster DNS server moves to the new master. All the pods are moved as described
above in Node failure.

###Pod failure
If a pod fails, it is automatically restarted. At this time, application level
health monitoring is not supported.
