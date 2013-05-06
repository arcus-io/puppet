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
