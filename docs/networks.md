#Networking

Containers are first class network endpoints with Project 6 and get an IP address
allocated to them. There is no overhead of configuring and managing port mappings.

Creation of a network is needed for selecting IP addresses for each of the Pods.
The IP address assignment is stable (not freed until the pod is deleted) and is
also backed by a builtin cluster DNS. At the time of creating a cluster, a pod DNS
domain can be specified. Cluster DNS has an entry for each pod in the format
"pod-name.pod-DNS-domain".

Pods can connect to each other using pod DNS names. To connect external applications
to pods by DNS names, point your external DNS server to the Virtual IP of the
cluster for the pod DNS domain.

Current implementation makes the following assumptions and is targeted at small,
trial deployments.
- Layer 2 Top of Rack switch
- vlan spans all nodes

There are many planned enhancements that will be announced in the near future
which will overcome these limitations.

##Networks

The below command creates a network called "blue".

```
$ dwctl network create blue -s 192.168.30.0/24 --start 192.168.30.101 \
--end 192.168.30.200 -g 192.168.30.1 -v 10
NAME      START ADDRESS    TOTAL     USED      GATEWAY        V[X]LAN
blue      192.168.30.101   100       0         192.168.30.1   10
```

##MAC pools
There is a default MAC pool already created that is used to assign MAC addresses
to each container. A new MAC pool can be creating using the command below.

```
dwctl macpool create pool0 E8:66:C6:00:00:00 1000
NAME	START ADDRESS		TOTAL	USED
----	-------------		-----	----
pool0	E8:66:C6:00:00:00	1000	0
```
