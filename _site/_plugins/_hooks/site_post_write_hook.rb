Jekyll::Hooks.register(:site, :post_write) do |site|
  pdfs_dir = File.join(site.dest, site.config['pdf_dir'] || 'pdfs')

  Dir.mkdir(pdfs_dir) unless File.directory?(pdfs_dir)

  site.pages.each do |page|
    if page.html?
      prince_commands(
        File.join(pdfs_dir, "#{page.basename}-#{File.mtime(page.destination('')).strftime('%F')}.pdf"),
        page.destination('')
      )
    end
  end
end

BEGIN {
  def prince_commands(pdf, html)
    commands = [
      %Q`prince --javascript --media=print --script=public_html/assets/js/print.js --style=public_html/assets/css/print.css -o #{pdf} #{html}`,
      %Q`ruby -EASCII-8BIT -i -p -e 'found ||= false' -e 'line = $_.sub!(/^\\/Annots \\[\\d+ \\d R \\d+ \\d R /, "/Annots [") unless found' -e 'found = true unless line.nil?' #{pdf}`
    ]
    %x(#{commands.join(';')})
  end
}
