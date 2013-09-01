class RubyTapasDownloader::FeedFetcher
  attr_reader :agent

  def initialize agent
    @agent = agent
  end

  def fetch
    agent.get(RubyTapasDownloader::Config.urls[:feed]).body
  end
end
