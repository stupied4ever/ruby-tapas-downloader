require_relative '../lib/ruby-tapas-downloader'

RubyTapasDownloader.logger = Object.new.tap do |logger|
  def logger.method_missing(*)
  end
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
