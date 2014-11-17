# The File resource of an Episode.
class RubyTapasDownloader::Downloadables::File <
                                              RubyTapasDownloader::Downloadable

  # @return [String] the name of the File.
  attr_reader :name

  # @return [String] the link to download the File.
  attr_reader :link

  def initialize(name, link)
    @name = name
    @link = link
  end

  # Download the File.
  #
  # @param (see: RubyTapasDownloader::Downloadables::Catalog#download)
  def download(basepath, agent)
    FileUtils.mkdir_p basepath

    file_path = File.join(basepath, name)
    if File.exist? file_path
      RubyTapasDownloader.logger.debug "Skipping downloaded file `#{ name }' " \
        "in `#{ file_path }'..."
    else
      RubyTapasDownloader.logger.info "Starting download of file `#{ name }' " \
        "in `#{ file_path }'..."
      agent.download link, file_path
    end
  end

  def ==(other)
    name == other.name && link == other.link
  end

  def eql?(other)
    name.eql?(other.name) && link.eql?(other.link)
  end

  def hash
    name.hash + link.hash
  end
end
