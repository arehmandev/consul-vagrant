# Vagrant Consul cluster

All the details for the consul servers are kept in the vagrant_hosts.yml
To see the Consul ui navigate to any of the host IPs on port 8500

Feel free to add entries to the yml file - vagrant boxes are bootstrapped to join the cluster details stored in the yml file (ruby array created in Vagrantfile and passed into inline provisioner script)
