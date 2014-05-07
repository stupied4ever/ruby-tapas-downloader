require 'thor'
require 'user-configurations'

require_relative '../ruby-tapas-downloader'

# The Command Line Interface for Ruby Tapas Downloader.
class RubyTapasDownloader::CLI < Thor

  # User stored configs
  def self.configs
    @configs ||= UserConfigurations::Configuration.new('ruby-tapas-downloader')
  end

  # User stored params
  def self.params
    @params ||= RubyTapasDownloader::Params.new(configs)
  end

  # Long description for download action
  def self.download_long_description
    <<-LONG_DESC
To download you need to be authenticated, you have tree options:

- Pass the params described before

- Use `ruby-tapas-downloader configure`

- Pass/export env vars: #{ RubyTapasDownloader::Params::CONFIG_KEYS.join(',') }
    LONG_DESC
  end

  # Perform complete download procedure.
  desc 'download', 'Download new content'
  option :email,    required: true, default: params.email,    aliases: '-e'
  option :password, required: true, default: params.password, aliases: '-p'
  option :path,     required: true, default: params.path,     aliases: '-l'
  long_desc download_long_description
  def download
    create_agent
    login
    fetch_feed
    create_catalog
    download_catalog
  end

  # Configure user preferences
  desc 'configure -e foo@bar.com -p 123 -l .', 'Configure user preferences'
  option :email,    required: true, default: params.email,    aliases: '-e'
  option :password, required: true, default: params.password, aliases: '-p'
  option :path,     required: true, default: params.path,     aliases: '-l'
  def configure
    args = {
      RubyTapasDownloader::Params::EMAIL    => email,
      RubyTapasDownloader::Params::PASSWORD => password,
      RubyTapasDownloader::Params::PATH     => path
    }

    configs.store args
  end

  private

  def email
    options[:email]
  end

  def password
    options[:password]
  end

  def path
    options[:path]
  end

  def create_agent
    @agent = Mechanize.new
  end

  def login
    RubyTapasDownloader::Login.new(agent, email, password).login
  end

  def fetch_feed
    @feed = RubyTapasDownloader::FeedFetcher.new(agent, email, password).fetch
  end

  def create_catalog
    @catalog = RubyTapasDownloader::Extractors::Catalog.new.extract feed
  end

  def download_catalog
    @catalog.download path, agent
  end

  attr_accessor :agent, :feed
end
