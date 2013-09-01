# The contract for Extractors.
class RubyTapasDownloader::Extractor
  # Should be implemented by children.
  def extract
    fail NotImplementedError
  end
end
