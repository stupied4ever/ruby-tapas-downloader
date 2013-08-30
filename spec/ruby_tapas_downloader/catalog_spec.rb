require 'spec_helper'

describe RubyTapasDownloader::Catalog do
  subject(:catalog) { RubyTapasDownloader::Catalog.new feed }

  let(:feed) { File.read 'spec/fixtures/feed.xml' }

  describe '#episodes' do
    xit 'parses episodes from feed' do
      expect(catalog.episodes).to be_true
    end
  end

  describe '#==' do
    it 'compares episodes'
  end
end
