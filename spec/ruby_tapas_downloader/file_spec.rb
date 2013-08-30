require 'spec_helper'

describe RubyTapasDownloader::File do
  subject(:file) { RubyTapasDownloader::File.new name, link }

  let(:name) { 'an-awesome-screencast.mp4' }
  let(:link) { 'http://example.com/an-awesome-screencast.mp4'}

  specify('#name') { expect(file.name).to eq(name) }
  specify('#link') { expect(file.link).to eq(link) }

  describe '#download' do
    let(:basepath)     { '/tmp/ruby-tapas/some-episode' }
    let(:agent)        { double(download: true) }

    it 'creates folder for file' do
      expect(FileUtils).to receive(:mkdir_p).with(basepath)

      file.download basepath, agent
    end

    it 'downloads the file' do
      expect(agent).to receive(:download).with(link, File.join(basepath, name))

      file.download basepath, agent
    end
  end
end
