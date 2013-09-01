# The contract for Downloadables.
class RubyTapasDownloader::Downloadable
  # Should be implemented by children.
  def download
    fail NotImplementedError
  end
end
