#Replicator

Replicator is primarily used to run multiple instances of stateless applications.
It follows the pod create semantics with a couple of additional options.
- Replicas (how many copies to run)
- Selector (label used to identify pods controlled by this replicator)

The replicator numbering is different from the default Kubernetes implementation.
This is a nominal replication controller that will number pods from 0001 to X, X
being the number of replicas.

##Replicator create
```
$ dwctl replicator create nginx -i nginx:latest -r 3 -s app=nginx
CONTROLLER   CONTAINER(S)   IMAGE(S)       SELECTOR    REPLICAS
nginx        nginx          nginx:latest   app=nginx   3

$ dwctl pod list -l app=nginx
POD          IP               CONTAINER(S)   IMAGE(S)       HOST            LABELS      STATUS    CREATED
nginx-0001   192.168.30.201   nginx          nginx:latest   192.168.30.11   app=nginx   Running   15 seconds
nginx-0002   192.168.30.203   nginx          nginx:latest   192.168.30.13   app=nginx   Running   15 seconds
nginx-0003   192.168.30.202   nginx          nginx:latest   192.168.30.12   app=nginx   Running   15 seconds
```

By default, the scheduler attempts to spread the pods belonging to a replicator.
If strict spreading is desired, use the -x option to specify conflict.

##Replicator update

To increase/decrease the number of instances of the application, use the update
command.

```
$ dwctl replicator update nginx -r 4
CONTROLLER   CONTAINER(S)   IMAGE(S)       SELECTOR    REPLICAS
nginx        nginx          nginx:latest   app=nginx   4

$ dwctl pod list -l app=nginx
POD          IP               CONTAINER(S)   IMAGE(S)       HOST            LABELS      STATUS    CREATED
nginx-0001   192.168.30.201   nginx          nginx:latest   192.168.30.11   app=nginx   Running   4 minutes
nginx-0002   192.168.30.203   nginx          nginx:latest   192.168.30.13   app=nginx   Running   4 minutes
nginx-0003   192.168.30.202   nginx          nginx:latest   192.168.30.12   app=nginx   Running   4 minutes
nginx-0004   192.168.30.106   nginx          nginx:latest   192.168.30.11   app=nginx   Running   10 seconds
```
