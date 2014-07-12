describe RubyTapasDownloader::FeedFetcher do
  subject(:feed_fetcher) do
    RubyTapasDownloader::FeedFetcher.new agent, email, password
  end

  let(:agent)    { instance_double Mechanize }
  let(:email)    { 'person@example.com' }
  let(:password) { 'chuncky bacon' }

  describe '#fetch' do
    subject(:fetched_feed) { feed_fetcher.fetch }

    let(:feed_string) { instance_double String }
    let(:feed)        { instance_double RSS::Rss }
    let(:feed_page)   { instance_double(Mechanize::Page, body: feed_string) }

    it 'fetches feed' do
      expect(agent).to receive(:add_auth)
                       .with(
                         RubyTapasDownloader::Config.urls[:feed],
                         email,
                         password
                       )

      expect(agent).to receive(:get)
                       .with(RubyTapasDownloader::Config.urls[:feed])
                       .and_return(feed_page)

      expect(RSS::Parser).to receive(:parse).with(feed_string).and_return(feed)

      expect(fetched_feed).to eq(feed)
    end
  end
end
