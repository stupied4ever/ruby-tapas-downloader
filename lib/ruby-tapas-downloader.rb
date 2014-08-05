require 'yaml'
require 'fileutils'
require 'rss'
require 'rexml/document'
require 'set'
require 'cgi'
require 'logger'
require 'pathname'

# Root module for Ruby Tapas downloader
module RubyTapasDownloader
  class << self
    # The Logger for RubyTapasDownloader.
    attr_writer :logger

    # @return [Logger] the Logger for RubyTapasDownloader
    def logger
      @logger ||= Logger.new STDOUT
    end
  end
end

require 'bundler/setup'
require 'mechanize'

require_relative 'ruby_tapas_downloader/exceptions'
require_relative 'ruby_tapas_downloader/downloadables'

require_relative 'ruby_tapas_downloader/extractors'

require_relative 'ruby_tapas_downloader/config'
require_relative 'ruby_tapas_downloader/login'
require_relative 'ruby_tapas_downloader/feed_fetcher'
