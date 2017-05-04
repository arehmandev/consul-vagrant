require 'yaml'

def machineiplist
  vagrant_hosts ||= []
  list = YAML.load_file('vagrant_hosts.yml')
  list.each do |list|
    vagrant_ips = list['ip']
    vagrant_hosts.push(vagrant_ips)
  end
  return [vagrant_hosts].join(' ')
end


print machineiplist

#print "(#{yaml["myarray"].join(' ')})"
