module RubyTapasDownloader
  # Catalog is the set of all Ruby Tapas Episodes.
  class Downloadables::Catalog < Downloadable
    # @return [Set<RubyTapasDownloader::Downloadables::Episode>] the Episodes.
    attr_reader :episodes

    def initialize(episodes)
      @episodes = episodes
    end

    # Download the Catalog.
    #
    # @param basepath [String] the path to place download.
    # @param agent [Mechanize] the Mechanize agent.
    def download(basepath, agent)
      RubyTapasDownloader.logger.info 'Starting download of catalog in ' \
                                      "`#{ basepath }'..."
      unless nice_download_path? basepath
        fail Exceptions::BadDownloadPath, basepath
      end

      episodes.each { |episode| episode.download basepath, agent }
    end

    def ==(other)
      episodes == other.episodes
    end

    def eql?(other)
      episodes.eql? other.episodes
    end

    def hash
      episodes.hash
    end

    private

    def nice_download_path?(basepath)
      File.directory?(basepath)
    end
  end
end
