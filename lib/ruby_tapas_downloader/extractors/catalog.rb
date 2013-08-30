class RubyTapasDownloader::Extractors::Catalog < RubyTapasDownloader::Extractor
  def initialize episode_extractor =
                                   RubyTapasDownloader::Extractors::Episode.new
    @episode_extractor = episode_extractor
  end

  def extract feed
    episodes = Set.new

    feed.items.each { |item|
      episodes << @episode_extractor.extract(item)
    }

    RubyTapasDownloader::Downloadables::Catalog.new episodes
  end
end
