module Puppet::Parser::Functions
  newfunction(:get_arcus_modules, :type => :rvalue) do |args|
    require 'yaml'
    require 'uri'
    require 'net/http'

    node = lookupvar('fqdn')
    url = args[0] || "https://nucleo.arcus.io/api/v1"
    api_key = args[1] || nil
    uri = URI.parse("#{url}/nodes/#{node}/enc")
    require 'net/https' if uri.scheme == 'https'
    request = Net::HTTP::Get.new(uri.path, initheader = {'Accept' => 'text/yaml', 'api-key' => api_key})
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end
    result = http.start {|http| http.request(request)}
    yml = YAML.load(result.body)
    yml['classes']
  end
end
