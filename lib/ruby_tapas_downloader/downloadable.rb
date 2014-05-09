# The contract for Downloadables.
class RubyTapasDownloader::Downloadable
  # Should be implemented by children.
  def download basepath, agent
    fail NotImplementedError
  end
end
