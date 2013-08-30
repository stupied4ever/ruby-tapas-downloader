class RubyTapasDownloader::File
  attr_reader :name
  attr_reader :link

  def initialize name, link
    @name = name
    @link = link
  end

  def download basepath, agent
    FileUtils.mkdir_p basepath

    agent.download link, File.join(basepath, name)
  end
end
