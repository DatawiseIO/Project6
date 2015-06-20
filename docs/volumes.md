#Volumes

Storage is a first class object in Project6. Most other orchestration systems
are focused on using the storage that is already provisioned. Instead, Project6
pools storage from disks of all nodes in the cluster. It is meant for bare
metal on premises deployment. To try this outside of the vagrant setup, please
contact us at project6@datawise.io.

Volumes are scheduled to a node based on storage requirement and the available
storage capacity on that node.

#Types of volumes
There are two types of volumes - persistent and temporary.

Persistent volumes are explicitly created using ```dwctl volume create```. They
are named and scheduled to a node. A pod wanting to use a persistent volume needs
to refer to the volume at the time of creation.

Temporary volumes are tied to the lifecycle of the pod and dont need to managed
by the user.

##Persistent volume creation
```
$ dwctl volume create wp-vol -v vol1,1G,ext4
GROUP     VOLUME    SIZE      FSTYPE    HOST      LABELS    STATUS    CREATED
wp-vol    vol1      1G        ext4                <none>    Pending   Less than a second

$ dwctl volume list
GROUP     VOLUME    SIZE      FSTYPE    HOST            LABELS    STATUS      CREATED
wp-vol    vol1      1G        ext4      192.168.30.11   <none>    Available   24 seconds
```

Multiple volumes can be created together on a node by using the -v option multiple
times. The aggregate storage capacity of all these volumes is used to schedule the
volume group. Once the volume is scheduled and created, it transitions to Available
status. If there is no storage available, the volume remains in Pending state.

Volumes can be scheduled to different nodes using the same labels and conflicts
concept as pods. This is useful for deploying clustered apps like zookeeper &
cassandra.

##Using a persistent volume
```
dwctl pod create mysql -i docker.io/mysql:latest \
-v wp-vol/vol1:/var/lib/mysql,rw -e MYSQL_ROOT_PASSWORD=root
```

As of now, this pod can only be scheduled to a node where its persistent volume is
scheduled. If for some reason, the persistent volume is not scheduled, the pod
remains in pending state until the persistent volume is scheduled.

##Using a temporary volume

When a pod needs temporary storage, it can use a temporary volume. Storage capacity
also becomes a scheduling criterion for selecting a node for this pod.

```
dwctl pod create wordpress -i docker.io/wordpress:4.2.2 \
-v /var/www/html,rw,100M,ext4 \
-e WORDPRESS_DB_HOST=172.16.1.106,WORDPRESS_DB_USER=root,WORDPRESS_DB_PASSWORD=root
```

In the above example, a 100M volume is created with ext4 filesystem and is mounted
at /var/www/html in read-write mode inside the container.
