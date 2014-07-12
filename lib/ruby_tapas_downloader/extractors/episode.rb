# Extract an Episode from an Feed Item.
class RubyTapasDownloader::Extractors::Episode < RubyTapasDownloader::Extractor
  # @param files_extractor [RubyTapasDownloader::Extractors::Files] the
  #   Files Extractor.
  def initialize(files_extractor = RubyTapasDownloader::Extractors::Files.new)
    @files_extractor = files_extractor
  end

  # @param item [RSS::Rss::Channel::Item] the feed item extracted with
  #   `feed.items[i]`.
  # @return [RubyTapasDownloader::Downloadables::Episode] the Episode extracted
  #   from feed item.
  def extract(item)
    title = CGI.unescapeHTML item.title
    link  = item.link
    files = @files_extractor.extract item.description

    RubyTapasDownloader::Downloadables::Episode.new title, link, files
  end
end
