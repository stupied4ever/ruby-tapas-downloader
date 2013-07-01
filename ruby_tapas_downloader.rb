require 'logger'
require 'open-uri'
require 'rss'
require 'rexml/document'

class RubyTapasDownloader
  FEED_URL = 'https://rubytapas.dpdcart.com/feed'

  class Options
    attr_reader :username
    attr_reader :password
    attr_reader :episodes_path

    def initialize args
      self.username, self.password, self.episodes_path = args
      if [username, password].any?(&:nil?)
        warn 'Usage: ruby ruby_tapas_downloader.rb <username> <password> ' \
             '[episodes_path]'
        exit 1
      end
      self.episodes_path ||= 'episodes'
    end

    protected

      attr_writer :username
      attr_writer :password
      attr_writer :episodes_path
  end

  class Episode
    class File
      attr_reader :title
      attr_reader :url

      def initialize title, url
        self.title = title
        self.url   = url
      end

      protected

        attr_writer :title
        attr_writer :url
    end

    attr_reader :title
    attr_reader :files

    def initialize title, files
      self.title = title
      self.files = files
    end

    def canonical_title
      title.downcase.gsub(/\s+/, '-')
    end

    protected

      attr_writer :title
      attr_writer :files
  end

  attr_reader :options

  def initialize args
    self.options = Options.new args
  end

  def start
    download episodes
  end

  def episodes
    if @episodes.nil?
      self.class.logger.info 'Starting retrieval of episodes using feed ' \
                             "from `#{ FEED_URL }'"
      rss  = open(FEED_URL,
                  http_basic_authentication: [options.username,
                                              options.password]).read
      feed = RSS::Parser.parse rss
      @episodes = feed.items.map { |item|
        description = REXML::Document.new item.description
        files = description.elements.to_a('//li//a').map { |link|
          Episode::File.new link.text, link.attribute('href').value
        }
        Episode.new item.title, files
      }
    end
    @episodes
  end

  def download episodes
    Array(episodes).each do |episode|
      self.class.logger.info "Starting download of episode " \
                             "`#{ episode.title }'"
      episode_path = File.join options.episodes_path, episode.canonical_title
      FileUtils.mkdir_p episode_path
      episode.files.each do |episode_file|
        file_path = File.join(episode_path, episode_file.title)
        if File.exists? file_path
          self.class.logger.debug "Skipping download of already existing " \
                                  "file `#{ file_path }'"
        else
          self.class.logger.info "Starting download of file `#{ file_path }'"
          open(episode_file.url, 'rb') do |content|
            File.open(file_path, 'wb') do |file|
              file.write content
            end
          end
        end
      end
    end
  end

  class << self
    attr_writer :logger

    def logger
      @logger ||= Logger.new(STDOUT).tap do |logger|
        unless %w(1 true yes).include? ENV['VERBOSE']
          logger.level = Logger::INFO
        end
      end
    end
  end

  protected

    attr_writer :options
end

RubyTapasDownloader.new(ARGV).start
