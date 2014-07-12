require 'spec_helper'

describe RubyTapasDownloader::Downloadables::Episode do
  subject(:episode) {
    RubyTapasDownloader::Downloadables::Episode.new title, link, files
  }

  let(:title)           { '999 Some: Ruby Tapas Episode with <<' }
  let(:link)            { 'http://example.com' }
  let(:files)           { [double(download: true), double(download: true)] }
  let(:sanitized_title) { '999-some-ruby-tapas-episode-with-<<' }

  specify('#title') { expect(episode.title).to eq(title) }
  specify('#link' ) { expect(episode.link ).to eq(link ) }
  specify('#files') { expect(episode.files).to eq(files) }
  specify '#sanitized_title' do
    expect(episode.sanitized_title).to eq(sanitized_title)
  end

  it 'is downloadable' do
    expect(episode).to be_a RubyTapasDownloader::Downloadable
  end

  describe '#download' do
    let(:basepath)     { '/tmp/ruby-tapas' }
    let(:agent)        { double }
    let(:episode_path) { File.join basepath, sanitized_title }

    before { allow(FileUtils).to receive(:mkdir_p) }

    it 'creates folder for episode with sanitized title' do
      expect(FileUtils).to receive(:mkdir_p).with(episode_path)

      episode.download basepath, agent
    end

    it 'calls #download on each file' do
      files.each do |file|
        expect(file).to receive(:download).with(episode_path, agent)
      end

      episode.download basepath, agent
    end
  end

  describe '#==' do
    it 'compares title, link and files' do
      expect(episode).to eq(
           RubyTapasDownloader::Downloadables::Episode.new title, link, files)
    end
  end

  describe '#eql?' do
    it 'compares title, link and files' do
      expect(
        episode.eql?(
          RubyTapasDownloader::Downloadables::Episode.new title, link, files)
      ).to be_truthy
    end
  end

  describe '#hash' do
    it 'is based on title, link and files' do
      expect(episode.hash).to eq(title.hash + link.hash + files.hash)
    end
  end
end
