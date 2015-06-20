# DNS

In Project6, cluster wide DNS can be configured during cluster create. It
allows applications & services running on containers to discover each other
with out the need of external DNS. DNS entries are automatically updated when a
new container is created or deleted.

## Enabling DNS
DNS is enabled by specifying --poddns option during cluster create.
Example:
```
$ dwctl cluster create mycluster 192.168.30.11,192.168.30.12,192.168.30.13 \
--vip 192.168.30.10 --poddns mycluster.datawise.io
```

DNS service is highly available and serves requests on cluster virtual
IP.
