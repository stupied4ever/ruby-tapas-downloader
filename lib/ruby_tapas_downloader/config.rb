# Retrieve configurations.
class RubyTapasDownloader::Config
  class << self
    # Retrieve urls stored in `urls.yml`.
    # @return [Hash] the urls stored in `urls.yml`.
    def urls
      @urls ||= YAML.load_file urls_config_path
    end

    private

    def urls_config_path
      Pathname File.expand_path('../../../config/urls.yml', __FILE__)
    end
  end
end
