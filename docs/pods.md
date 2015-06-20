#Pods

##What is a Pod
Pod is a collection of one or more containers that need to be scheduled together.
For a more detailed description of pods, see this Kubernetes [link](https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/pods.md)

##Creating a Pod
For creating a pod, these are the attributes that can be specified. Name and Image
attributes are mandatory, the rest are optional. 

* Name
* Image
* CPU       (shares or millcores)
* Memory    (can be expressed in bytes, KB, MB, GB)
* Network   (if no network is configured, the pod remains in pending state)
* Storage   (persistent or temporary and where to  mount it)
* Labels    (labels are useful to search pods or to drive scheduling decision)
* Selectors (Used to match nodes that have these labels)
* Conflicts (Used to prevent conflicting pods from being scheduled together)
* Env Vars  (Environment variables that are passed to the application)

A pod can be created using ```dwctl pod create``` or ```dwctl run```.

###A simple example
```
$ dwctl run nginx -i nginx:latest
```

To check where the pod is scheduled and its status:
```
$ dwctl pod list
```
OR
```
$ dwctl pod get nginx
POD       IP               CONTAINER(S)   IMAGE(S)       HOST            LABELS    STATUS    CREATED
nginx     192.168.30.106   nginx          nginx:latest   192.168.30.13   <none>    Pending   7 seconds
```

Note that each Pod gets a unique IP for itself. This IP is allocated from a
pre-created network pool.

If the pod is in pending state, it means that some of the resources it needs are
not available. This could be an image download in progress, a missing network or
exhaustion of storage capacity. Use ```dwctl event list -p nginx``` to list events
related to this pod.

###Scheduling a pod to a specific set of nodes
Lets say there are a few nodes with SSDs in the cluster and a pod needs to be
scheduled to those nodes.

Step 1 - tag a node
```
$ dwctl node tag 192.168.30.13 ssd
NAME            LABELS    STATUS
192.168.30.13   ssd       Schedulable,Ready
```

Step 2 - specify a selector with pod creation.
```
$ dwctl run nginx -i nginx:latest -s ssd
POD       IP        CONTAINER(S)   IMAGE(S)       HOST           LABELS    STATUS    CREATED
nginx               nginx          nginx:latest   <unassigned>   <none>    Pending   Less than a second

$ dwctl pod get nginx
POD       IP               CONTAINER(S)   IMAGE(S)       HOST            LABELS    STATUS    CREATED
nginx     192.168.30.106   nginx          nginx:latest   192.168.30.13   <none>    Pending   7 seconds

```

###Scheduling two pods away from each other
If two pods need to be scheduled on different nodes, conflicts can be used to
achieve that.
```
$ dwctl run nginx1 -i nginx:latest -l app=nginx -x app=nginx
$ dwctl run nginx2 -i nginx:latest -l app=nginx -x app=nginx

$ dwctl pod list -l app=nginx
POD       IP               CONTAINER(S)   IMAGE(S)       HOST            LABELS      STATUS    CREATED
nginx1    192.168.30.106   nginx1         nginx:latest   192.168.30.11   app=nginx   Running   17 seconds
nginx2    192.168.30.107   nginx2         nginx:latest   192.168.30.12   app=nginx   Pending   12 seconds
```

###Listing pods
```dwctl pod list``` lists all the running pods in the cluster including the
builtin service pods.