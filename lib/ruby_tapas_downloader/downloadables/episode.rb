# An Ruby Tapas Episode.
class RubyTapasDownloader::Downloadables::Episode <
                                              RubyTapasDownloader::Downloadable

  # @return [String] the title of the Episode.
  attr_reader :title

  # @return [String] the link to the Episode.
  attr_reader :link

  # @return [Set<RubyTapasDownloader::Downloadables::File>] the Set of Files
  #   for that episode.
  attr_reader :files

  def initialize title, link, files
    @title = title
    @link  = link
    @files = files
  end

  # Clean title to be used in path names.
  #
  # @return [String] the sanitized title.
  def sanitized_title
    @sanitized_title ||= title.downcase.gsub(/[^\w<>#?!$]+/, '-')
  end


  # Download the Episode.
  #
  # @param (see: RubyTapasDownloader::Downloadables::Catalog#download)
  def download basepath, agent
    episode_path = File.join basepath, sanitized_title
    RubyTapasDownloader.logger.info 'Starting download of episode ' \
                                    "`#{ title }' in `#{ episode_path }'..."
    FileUtils.mkdir_p episode_path
    files.each { |file| file.download episode_path, agent }
  end

  def == other
    title == other.title && link == other.link && files == other.files
  end

  def eql? other
    title.eql?(other.title) && link.eql?(other.link) && files.eql?(other.files)
  end

  def hash
    title.hash + link.hash + files.hash
  end
end
