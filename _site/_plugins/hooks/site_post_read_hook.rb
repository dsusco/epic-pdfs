require 'json'
require 'net/http'
require 'uri'

Jekyll::Hooks.register :site, :post_read do |site|
  json_path = File.join('json')
  Dir.mkdir(json_path) unless Dir.exist?(json_path)

  site.collections.each do |label, collection|
    json_path = File.join('json', "#{label}.json")

    if File.exist?(json_path)
      json = File.read(json_path)
    else
      tp_response = Net::HTTP.get_response(URI("https://tp.net-armageddon.org/assets/json/#{label}.json"))
      next unless tp_response.is_a?(Net::HTTPSuccess)
      json = tp_response.body
      File.write(json_path, json)
    end

    site.data[label] =
      collection.docs.reduce(JSON.parse(json)) do |hash, doc|
        doc.data['mtime'] = File.mtime(File.join(site.source, doc.relative_path))
        hash[doc.data['slug']] = doc
        hash
      end
  end
end
