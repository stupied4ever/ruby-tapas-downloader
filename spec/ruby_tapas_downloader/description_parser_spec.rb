require 'spec_helper'

describe RubyTapasDownloader::DescriptionParser do
  subject(:description_parser) {
    RubyTapasDownloader::DescriptionParser.new
  }

  describe '#parse' do
    subject(:files) { description_parser.parse feed_description }

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
