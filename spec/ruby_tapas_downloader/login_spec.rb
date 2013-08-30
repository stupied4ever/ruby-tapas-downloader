require 'spec_helper'

describe RubyTapasDownloader::Login do
  subject(:ruby_tapas_downloader) {
    RubyTapasDownloader::Login.new agent, email, password
  }

  let(:agent)    { double }
  let(:email)    { 'someone@example.com' }
  let(:password) { 'chunky bacon' }

  it 'requests the login page' do
    expect(agent).to receive(:get).with(RubyTapasDownloader::Config.urls
                                                                .fetch(:login))
    ruby_tapas_downloader.perform
  end

  it 'fills in the login form'
  it 'submits the login form'
end
