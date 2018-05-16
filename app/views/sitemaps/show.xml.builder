xml.instruct!

xml.urlset "xmlns" => "http://www.google.com/schemas/sitemap/0.9", "xmlns:xhtml" => "http://www.w3.org/1999/xhtml" do
  xml.url do
    xml.loc "#{request.protocol}#{request.host}/registers"

    xml.lastmod Date.today.to_date
    xml.changefreq "weekly"
    xml.priority 0.9
  end

  xml.url do
    xml.loc "#{request.protocol}#{request.host}/registers-in-progress"

    xml.lastmod Date.today.to_date
    xml.changefreq "weekly"
    xml.priority 0.9
  end

  @registers.each do |register|
    xml.url do
      xml.loc "#{request.protocol}#{request.host}/registers/#{register.slug}"

      xml.lastmod register.updated_at.to_date
      xml.changefreq "weekly"
      xml.priority 0.9
    end
  end

  xml.url do
    xml.loc "#{request.protocol}#{request.host}/support"

    xml.lastmod Date.today.to_date
    xml.changefreq "weekly"
    xml.priority 0.9
  end

  xml.url do
    xml.loc "#{request.protocol}#{request.host}/services-using-registers"

    xml.lastmod Date.today.to_date
    xml.changefreq "weekly"
    xml.priority 0.9
  end
end
