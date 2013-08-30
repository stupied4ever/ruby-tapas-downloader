require 'spec_helper'

describe RubyTapasDownloader::Episode do
  subject(:episode) { RubyTapasDownloader::Episode.new title, link, files }

  let(:title)           { '999 Some: Ruby Tapas Episode with <<' }
  let(:sanitized_title) { '999-some-ruby-tapas-episode-with-<<' }
  let(:link)            { 'http://example.com' }
  let(:files)           { [double, double, double] }

  specify('#title') { expect(episode.title).to eq(title) }
  specify('#link' ) { expect(episode.link ).to eq(link ) }
  specify('#files') { expect(episode.files).to eq(files) }
  specify '#sanitized_title' do
    expect(episode.sanitized_title).to eq(sanitized_title)
  end
end
