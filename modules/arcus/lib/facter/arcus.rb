require 'yaml'

Facter.add("arcus_organization") do
  setcode do
    organization = nil
    begin
      cfg = File::open('/etc/arcus.yaml')
      yml = YAML::load(cfg.read())
      organization = yml['organization']
    rescue
      puts 'Unable to read /etc/arcus.yaml'
    end
    puts organization
    organization
  end
end
