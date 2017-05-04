# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
require 'rbconfig'


$script = <<SCRIPT

echo "Installing dependencies ..."
sudo apt-get update
sudo apt-get install -y unzip curl jq

echo "Determining Consul version to install ..."
CHECKPOINT_URL="https://checkpoint-api.hashicorp.com/v1/check"
if [ -z "$CONSUL_DEMO_VERSION" ]; then
    CONSUL_DEMO_VERSION=$(curl -s "${CHECKPOINT_URL}"/consul | jq .current_version | tr -d '"')
fi

echo "Fetching Consul version ${CONSUL_DEMO_VERSION} ..."
cd /tmp/
curl -s https://releases.hashicorp.com/consul/${CONSUL_DEMO_VERSION}/consul_${CONSUL_DEMO_VERSION}_linux_amd64.zip -o consul.zip

echo "Installing Consul version ${CONSUL_DEMO_VERSION} ..."
unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul

sudo mkdir /etc/consul.d
sudo chmod a+w /etc/consul.d

EXPECTED_SIZE=${#FULLIPLIST[@]}

FULLIPLIST=($ARRAY)

echo "$ARRAY" >> /home/vagrant/vagranthosts.txt



consul agent -server -ui \
  -bind="$VAGRANT_IP" \
  -client="0.0.0.0" \
  -retry-join="${FULLIPLIST[0]}" \
  -retry-join="${FULLIPLIST[1]}" \
  -retry-join="${FULLIPLIST[2]}" \
  -bootstrap-expect="$EXPECTED_SIZE" \
  -data-dir=/tmp & sleep 1

SCRIPT



# Specify a Consul version
CONSUL_DEMO_VERSION = ENV['CONSUL_DEMO_VERSION']

# Specify a custom Vagrant box for the demo
DEMO_BOX_NAME = ENV['DEMO_BOX_NAME'] || "debian/jessie64"

# Vagrantfile API/syntax version.
# NB: Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Load variables from vagrant_hosts.yml
hosts = YAML.load_file('vagrant_hosts.yml')

# Create array of vagrant host IPs
def machineiplist
  vagrant_hosts ||= []
  list = YAML.load_file('vagrant_hosts.yml')
  list.each do |list|
    vagrant_ips = list['ip']
    vagrant_hosts.push(vagrant_ips)
  end
  return [vagrant_hosts].join(' ')
end


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
#  echo machineiplist
#  IP_LIST = machineiplist
  hosts.each do |host|
    config.vm.define host['name'] do |node|
        node.vm.box = DEMO_BOX_NAME
        node.vm.hostname = host['name']
        node.vm.network "private_network", ip: host['ip']
        node.vm.provision "shell",
                                inline: $script,
                                env: {
                                  'CONSUL_DEMO_VERSION' => CONSUL_DEMO_VERSION,
                                  'VAGRANT_IP' => host['ip'],
                                  'ARRAY' => machineiplist
                                }

       node.vm.provider :virtualbox do |vb|
         vb.name = host['name']
       end
     end
   end
end