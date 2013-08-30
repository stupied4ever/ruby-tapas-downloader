class RubyTapasDownloader::Episode
  include RubyTapasDownloader::Downloadable

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

  def download basepath, agent
    episode_path = File.join basepath, sanitized_title
    FileUtils.mkdir_p episode_path
    files.each { |file| file.download episode_path, agent }
  end

  def == other
    title = other.title && link == other.link && files == other.files
  end

  def eql? other
    title.eql?(other.title) && link.eql?(other.link) && files.eql?(other.files)
  end

  def hash
    title.hash + link.hash + files.hash
  end
end
