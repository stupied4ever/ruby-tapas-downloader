# Extract an Catalog from an Feed.
class RubyTapasDownloader::Extractors::Catalog < RubyTapasDownloader::Extractor
  # @param episode_extractor [RubyTapasDownloader::Extractors::Episode] the
  #   Episode Extractor.
  def initialize episode_extractor =
                                   RubyTapasDownloader::Extractors::Episode.new
    @episode_extractor = episode_extractor
  end

  # @param feed [RSS::Rss] the feed extracted with `RSS::Parser.parse`.
  # @return [RubyTapasDownloader::Downloadables::Catalog] the Catalog extracted
  #   from feed.
  def extract feed
    episodes = Set.new

    feed.items.each { |item|
      episodes << @episode_extractor.extract(item)
    }

    RubyTapasDownloader::Downloadables::Catalog.new episodes
  end
end
