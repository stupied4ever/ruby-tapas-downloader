# Fetches feed from Ruby Tapas.
class RubyTapasDownloader::FeedFetcher
  # @return [Mechanize] the Mechanize agent.
  attr_reader :agent

  # @return [String] the e-mail for the user.
  attr_reader :email

  # @return [String] the password for the user.
  attr_reader :password

  def initialize agent, email, password
    @agent    = agent
    @email    = email
    @password = password
  end

  # Fetch feed from Ruby Tapas.
  #
  # @return [RSS::Rss] the feed for Ruby Tapas.
  def fetch
    RubyTapasDownloader.logger.info 'Fetching episodes feed...'

    feed_url = RubyTapasDownloader::Config.urls[:feed]

    agent.add_auth feed_url, email, password
    RSS::Parser.parse agent.get(feed_url).body
  end
end
