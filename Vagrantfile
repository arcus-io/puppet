# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.provision :shell, :path => "provision.sh"
  config.ssh.forward_agent = true

  config.vm.define :puppetmaster do |pm_config|
    pm_config.vm.host_name = "puppet.local"
    pm_config.vm.network :hostonly, "10.10.10.25"
    pm_config.vm.forward_port 80, 8180 # http
    pm_config.vm.forward_port 8080, 8080 # http-puppetdb-dashboard
    pm_config.vm.forward_port 8081, 8081 # http-puppetdb
    pm_config.vm.forward_port 443, 8143 # https
    pm_config.vm.forward_port 3000, 3000 # puppet-dashboard
    pm_config.vm.forward_port 8140, 8140 # puppet
    pm_config.vm.share_folder "arcus_puppet", "/mnt/arcus-puppet", "./"
    pm_config.vm.share_folder "puppet_manifests", "/etc/puppet/manifests", "manifests"
    pm_config.vm.share_folder "puppet_modules", "/etc/puppet/modules", "modules"
  end

  config.vm.define :util do |util_config|
    util_config.vm.host_name = "util.local"
    util_config.vm.network :hostonly, "10.10.10.26"
    util_config.vm.forward_port 2003, 2003 # graphite
    util_config.vm.forward_port 2004, 2004 # graphite
    util_config.vm.forward_port 7002, 7002 # graphite
    util_config.vm.forward_port 80, 8026 # graphite
    util_config.vm.forward_port 8080, 8086 # sensu-dashboard
    util_config.vm.forward_port 9000, 9000 # sentry
  end

  config.vm.define :sandbox do |sandbox_config|
    sandbox_config.vm.host_name = "sandbox.local"
    sandbox_config.vm.network :hostonly, "10.10.10.27"
    sandbox_config.vm.forward_port 80, 8000 # http
    #sandbox_config.vm.forward_port 9000, 9000 # sentry
    #sandbox_config.vm.forward_port 5672, 5672 # rabbitmq
    sandbox_config.vm.forward_port 8990, 8990 # solr (haproxy)
    sandbox_config.vm.forward_port 8983, 8983 # solr
    #sandbox_config.vm.forward_port 55672, 55672 # rabbitmq-mgmt
    sandbox_config.vm.share_folder "puppet_modules", "/mnt/puppet_modules", "modules"
    sandbox_config.vm.share_folder "courseload", "/mnt/courseload", "../puppet-courseload/modules"
  end
end

Vagrant.configure("2") do |config|
    config.vm.provider :virtualbox do |vb|
        config.vm.define :puppetmaster do |pm|
            vb.customize ["modifyvm", :id, "--memory", 1024]
        end
    end

    config.vm.provider :vmware_fusion do |v|
      config.vm.define :puppetmaster do |pm|
        v.vmx["memsize"] = "1024"
      end
      config.vm.define :puppetmaster do |c|
        v.vmx["displayName"] = "puppetmaster"
      end
      config.vm.define :util do |c|
        v.vmx["displayName"] = "util"
      end
      config.vm.define :sandbox do |c|
        v.vmx["displayName"] = "sandbox"
      end
    end
end
