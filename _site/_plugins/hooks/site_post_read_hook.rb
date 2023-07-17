Jekyll::Hooks.register :site, :post_read do |site|
  site.collections.each do |label, collection|
    site.data[label] =
      collection.docs.reduce({}) do |hash, doc|
        hash[doc.data['slug']] = doc
        hash
      end
  end
end
