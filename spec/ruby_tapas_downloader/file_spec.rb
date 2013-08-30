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
    let(:file_path)    { File.join basepath, name }

    before { allow(FileUtils).to receive(:mkdir_p) }

    it 'creates folder for file' do
      expect(FileUtils).to receive(:mkdir_p).with(basepath)

      file.download basepath, agent
    end

    it 'downloads the file' do
      expect(agent).to receive(:download).with(link, file_path)

      file.download basepath, agent
    end

    it 'avoids repeating download' do
      allow(File).to receive(:exists?).with(file_path).and_return(true)
      expect(agent).to_not receive(:download)

      file.download basepath, agent
    end
  end

  describe '#==' do
    it 'compares name and link' do
      expect(file).to eq(RubyTapasDownloader::File.new(name, link))
    end
  end

  describe '#eql?' do
    it 'compares name and link' do
      expect(file.eql? RubyTapasDownloader::File.new(name, link)).to be_true
    end
  end

  describe '#hash' do
    it 'is based on name and link' do
      expect(file.hash).to eq(name.hash + link.hash)
    end
  end
end
