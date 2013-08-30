require 'spec_helper'

describe RubyTapasDownloader::Extractors::Episode do
  subject(:episode_extractor) {
    RubyTapasDownloader::Extractors::Episode.new files_extractor
  }

  let(:files_extractor) { double }

  it 'is an Extractor' do
    expect(episode_extractor).to be_a RubyTapasDownloader::Extractor
  end

  describe '#extract' do
    subject(:episode) { episode_extractor.extract item }

    let(:item) {
      RSS::Parser.parse(File.open('spec/fixtures/feed.xml')).items.first
    }

    let(:files) {
      Set[
        RubyTapasDownloader::Downloadables::File.new(
          'some-episode-file.html',
          'http://example.com/some-episode-file.html'),
        RubyTapasDownloader::Downloadables::File.new(
          'some-episode-file.mp4',
          'http://example.com/some-episode-file.mp4'),
        RubyTapasDownloader::Downloadables::File.new(
          'some-episode-file.rb',
          'http://example.com/some-episode-file.rb'),
      ]
    }

    before do
      allow(files_extractor).to receive(:extract).with(item.description)
                                                 .and_return(files)
    end

    it 'returns an Episode' do
      expect(episode).to eq(
        RubyTapasDownloader::Downloadables::Episode.new(
          '129 Some episode',
          'http://example.com/some-episode',
          files
        )
      )
    end
  end
end
