class RubyTapasDownloader::Extractors::Files < RubyTapasDownloader::Extractor
  def extract item_description
    files = Set.new
    document = REXML::Document.new item_description
    document.elements.each('//li/a') { |element|
      name = element.text
      link = element.attribute('href').to_s
      files << RubyTapasDownloader::Downloadables::File.new(name, link)
    }
    files
  end
end
