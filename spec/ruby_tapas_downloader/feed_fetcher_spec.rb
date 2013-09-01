require 'spec_helper'

describe RubyTapasDownloader::FeedFetcher do
  subject(:feed_fetcher) { RubyTapasDownloader::FeedFetcher.new agent }

  let(:agent) { double }

  describe '#fetch' do
    subject(:feched_feed) { feed_fetcher.fetch }
    let(:feed) { File.read 'spec/fixtures/feed.xml'}

    it 'fetches feed' do
      expect(agent).to receive(:get)
                       .with(RubyTapasDownloader::Config.urls[:feed])
                       .and_return(double body: feed)

      expect(feched_feed).to eq(feed)
    end
  end
end
