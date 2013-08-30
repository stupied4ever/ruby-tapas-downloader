class RubyTapasDownloader::Catalog
  def initialize feed
    @feed = feed
  end

  def episodes
    @episodes ||= extract_episodes_from_feed
  end

  private

  def extract_episodes_from_feed
    @feed.items.map { |item|

    }
  end
end
