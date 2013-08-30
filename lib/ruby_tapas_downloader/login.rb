class RubyTapasDownloader::Login
  attr_reader :agent
  attr_reader :email
  attr_reader :password

  def initialize agent, email, password
    @agent    = agent
    @email    = email
    @password = password
  end

  def perform
    agent.get RubyTapasDownloader::Config.urls.fetch(:login)
  end
end
