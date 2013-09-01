class RubyTapasDownloader::FeedFetcher
  attr_reader :agent

  def initialize agent
    @agent = agent
  end

  def fetch
    RubyTapasDownloader.logger.info 'Fetching episodes feed...'
    agent.get(RubyTapasDownloader::Config.urls[:feed]).body
  end
end
