class RubyTapasDownloader::FeedFetcher
  attr_reader :agent

  def initialize agent, email, password
    @agent    = agent
    @email    = email
    @password = password
  end

  def fetch
    RubyTapasDownloader.logger.info 'Fetching episodes feed...'

    feed_url = RubyTapasDownloader::Config.urls[:feed]

    agent.add_auth feed_url, @email, @password
    RSS::Parser.parse agent.get(feed_url).body
  end
end
