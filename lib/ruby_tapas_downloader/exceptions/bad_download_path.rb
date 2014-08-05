# Bad download path exception
class RubyTapasDownloader::Exceptions::BadDownloadPath < StandardError
  def initialize(download_path)
    super 'The following path isn\'t valid to place the downloaded Ruby Tapas'\
          " episodes: `<#{download_path}>"
  end
end
