# The contract for Downloadables.
class RubyTapasDownloader::Downloadable
  # Should be implemented by children.
  def download(_basepath, _agent)
    fail NotImplementedError
  end
end
