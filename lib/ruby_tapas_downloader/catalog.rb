class RubyTapasDownloader::Catalog
  include RubyTapasDownloader::Downloadable

  attr_reader :episodes

  def initialize episodes
    @episodes = episodes
  end

  def download basepath, agent
    FileUtils.mkdir_p basepath
    episodes.each { |episode| episode.download basepath, agent }
  end

  def == other
    episodes == other.episodes
  end

  def eql? other
    episodes.eql? other.episodes
  end

  def hash
    episodes.hash
  end
end
