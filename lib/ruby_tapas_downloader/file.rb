class RubyTapasDownloader::File
  attr_reader :name
  attr_reader :link

  def initialize name, link
    @name = name
    @link = link
  end

  def download basepath, agent
    FileUtils.mkdir_p basepath

    file_path = File.join(basepath, name)
    agent.download link, file_path unless File.exists? file_path
  end
end
