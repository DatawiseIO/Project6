# Logging

In Project6, centralized log management for pods is enabled by default.
Logs from all the pods are collected into elastic search backend and
are readily available for monitoring at the url: http://kibana-logging-0001.
The services to collect the logs from the pods are themselves configured to run
as default cluster-service pods. These pods are also listed in ``dwctl
pod list``

To resolve the hostnames, configure your client to point to Skydns running on
cluster virtual ip.

Note: Logging service requires cluster DNS service to be up and running.

##Disable Logging:
Logging can be disabled at run time using:
```
$ dwctl cluster configure -l disable
```

##Enable logging
Logging can be enabled at run time using:
```
$ dwctl cluster configure -l enable
```

# Statistics & Monitoring

Statistics & monitoring is enabled by default in Project6. Container metrics
are collected periodically in a centralized time series database. The metrics
can be viewed in grafana dashboard at the virtual-ip url: http://&lt;virtual-ip&gt;:8000

This is a work in progress. Expect more improvements to the grafana dashboard
soon.

