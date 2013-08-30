class RubyTapasDownloader::Episode
  attr_reader :title
  attr_reader :link
  attr_reader :files

  def initialize title, link, files
    @title = title
    @link  = link
    @files = files
  end

  def sanitized_title
    @sanitized_title ||= title.downcase.gsub(/[^\w<>]+/, '-')
  end

  def download path
    episode_path = File.join path, sanitized_title
    FileUtils.mkdir_p episode_path
    files.each { |file| file.download episode_path }
  end
end
