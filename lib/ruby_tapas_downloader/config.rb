class RubyTapasDownloader::Config
  def self.urls
    @urls ||= YAML.load File.read 'config/urls.yml'
  end
end
