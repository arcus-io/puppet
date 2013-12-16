module Puppet::Parser::Functions
  newfunction(:get_enc_classes, :type => :rvalue) do |args|
    require 'yaml'
    require 'uri'
    require 'net/http'
    begin
        node = lookupvar('fqdn')
        env = lookupvar('environment')
        uri = URI.parse("https://localhost:8140/#{env}/node/#{node}")
        require 'net/https' if uri.scheme == 'https'
        request = Net::HTTP::Get.new(uri.path, initheader = {'Accept' => 'yaml'})
        http = Net::HTTP.new(uri.host, uri.port)
        if uri.scheme == 'https'
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        result = http.start {|http| http.request(request)}
        yml = YAML.load(result.body)
        puts yml.classes
        yml.classes
    rescue
        []
    end
  end
end
