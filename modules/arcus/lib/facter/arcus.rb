require 'yaml'

Facter.add("arcus_key") do
  setcode do
    key = nil
    begin
      cfg = File::open('/etc/arcus.key')
      key = cfg.read()
    rescue
      puts 'Unable to read /etc/arcus.key'
    end
    key
  end
end

Facter.add("classes") do
  setcode do
    classes = Array.new
    begin
      cfg = File::open('/var/lib/puppet/state/classes.txt')
      while (line=cfg.gets)
        line = line.chomp
        # don't include the 'standard' classes we use but still include
        # custom classes in the modules
        filters = ['package', 'service', 'config', 'params']
        if not classes.include? line
          if line.index('::') and filters.include? line.split('::')[-1]
          else
            classes.push(line.chomp)
          end
        end
      end
    rescue
      puts 'Unable to read /var/lib/puppet/state/classes.txt'
    end
    # since puppet can't turn this into an array (http://projects.puppetlabs.com/issues/4395)
    # join the array with a comma to later parse
    classes.join(',')
  end
end
