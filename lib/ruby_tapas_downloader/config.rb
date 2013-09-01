# Retrieve configurations.
class RubyTapasDownloader::Config
  # Retrieve urls stored in `urls.yml`.
  # @return [Hash] the urls stored in `urls.yml`.
  def self.urls
    @urls ||= YAML.load File.read 'config/urls.yml'
  end
end
