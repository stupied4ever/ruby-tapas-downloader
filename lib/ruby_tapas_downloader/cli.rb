require 'thor'
require 'user-configurations'

require_relative '../ruby-tapas-downloader'

# The Command Line Interface for Ruby Tapas Downloader.
module RubyTapasDownloader
  class CLI < Thor
    # Long description for download action
    def self.download_long_description
      env_vars = RubyTapasDownloader::Config::CONFIG_KEYS.join(',')
      <<-LONG_DESC
To download you need to be authenticated, you have tree options:

- Pass the params described before

- Use `ruby-tapas-downloader configure`

- Pass/export env vars: #{ env_vars }
      LONG_DESC
    end

    # Perform complete download procedure.
    desc 'download', 'Download new content'
    option(
      :email, required: true, default: Config.default_email, aliases: '-e'
    )
    option(
      :password,
      required: true,
      default: Config.default_password,
      aliases: '-p'
    )
    option(:path, required: true, default: Config.default_path, aliases: '-l')
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
    option :email,    required: true, aliases: '-e'
    option :password, required: true, aliases: '-p'
    option :path,     required: true, aliases: '-l'
    def configure
      RubyTapasDownloader::Config.update(
        email: email, password: password, path: path
      )
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
end
