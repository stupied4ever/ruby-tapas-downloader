require 'spec_helper'

describe RubyTapasDownloader::Extractors::Files do
  subject(:files_extractor) {
    RubyTapasDownloader::Extractors::Files.new
  }

  describe '#extract' do
    subject(:files) { files_extractor.extract feed_description }

    let(:feed_description) { File.read 'spec/fixtures/feed_description.html' }

    it 'returns a Set of Files' do
      expect(files).to eq(
        Set[
          RubyTapasDownloader::File.new(
            'some-episode-file.html',
            'http://example.com/some-episode-file.html'),
          RubyTapasDownloader::File.new(
            'some-episode-file.mp4',
            'http://example.com/some-episode-file.mp4'),
          RubyTapasDownloader::File.new(
            'some-episode-file.rb',
            'http://example.com/some-episode-file.rb'),
        ]
      )
    end
  end
end
