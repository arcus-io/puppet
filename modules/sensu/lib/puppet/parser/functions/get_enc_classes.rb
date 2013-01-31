module Puppet::Parser::Functions
  newfunction(:get_enc_classes, :type => :rvalue) do |args|
    require 'yaml'
    require 'uri'
    require 'net/http'

    node = lookupvar('fqdn')
    url = args[0] || "https://puppet:8140"
    uri = URI.parse("#{url}/production/node/#{node}/")
    require 'net/https' if uri.scheme == 'https'
    request = Net::HTTP::Get.new(uri.path, initheader = {'Accept' => 'text/yaml'})
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
