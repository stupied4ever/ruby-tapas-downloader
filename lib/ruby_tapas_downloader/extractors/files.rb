class RubyTapasDownloader::Extractors::Files < RubyTapasDownloader::Extractor
  def extract feed_description
    files = Set.new
    document = REXML::Document.new feed_description
    document.elements.each('//li/a') { |element|
      name = element.text
      link = element.attribute('href').to_s
      files << RubyTapasDownloader::File.new(name, link)
    }
    files
  end
end
