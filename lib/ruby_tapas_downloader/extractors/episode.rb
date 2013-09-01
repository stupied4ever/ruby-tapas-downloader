class RubyTapasDownloader::Extractors::Episode < RubyTapasDownloader::Extractor
  def initialize files_extractor = RubyTapasDownloader::Extractors::Files.new
    @files_extractor = files_extractor
  end

  def extract item
    title = CGI.unescapeHTML item.title
    link  = item.link
    files = @files_extractor.extract item.description

    RubyTapasDownloader::Downloadables::Episode.new title, link, files
  end
end
