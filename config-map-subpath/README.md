  ## kubectl exec --stdin --tty pod_name -- sh
  - ls /etc/mysql/conf.d
  
Kubernetes took the map name of mysql_binlog_format.cnf present it as a filewith the contents that were stored in the data source of the configMap.
The problem however is it laid that volume on top of the existing directory.
The default configuration files for mysql are no longer present.
I'd have to create all the mysql configuration files and store them into the configMap.
Or, I can use a subPath.
