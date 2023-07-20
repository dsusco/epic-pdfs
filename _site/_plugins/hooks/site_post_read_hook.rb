require 'json'
require 'net/http'
require 'uri'

Jekyll::Hooks.register :site, :post_read do |site|
  site.collections.each do |label, collection|
    tp_response = Net::HTTP.get_response(URI("https://tp.net-armageddon.org/assets/json/#{label}.json"))

    next unless tp_response.is_a?(Net::HTTPSuccess)

    site.data[label] =
      collection.docs.reduce(JSON.parse(tp_response.body)) do |hash, doc|
        doc.data['mtime'] = File.mtime(File.join(site.source, doc.relative_path))
        hash[doc.data['slug']] = doc
        hash
      end
  end
end
