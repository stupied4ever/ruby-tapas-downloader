require 'spec_helper'

describe RubyTapasDownloader::Login do
  subject(:ruby_tapas_downloader) {
    RubyTapasDownloader::Login.new agent, email, password
  }

  let(:agent)    { Mechanize.new }
  let(:email)    { 'someone@example.com' }
  let(:password) { 'chunky bacon' }

  describe '#perform' do
    it 'requests the login page' do
      VCR.use_cassette('login') do
        ruby_tapas_downloader.perform
        expect(ruby_tapas_downloader.page.uri).to eq(
                          URI(RubyTapasDownloader::Config.urls.fetch(:login)))
      end
    end

    it 'fills in the login form' do
      VCR.use_cassette('login') do
        ruby_tapas_downloader.perform
        expect(ruby_tapas_downloader.login_form.username).to eq(email)
        expect(ruby_tapas_downloader.login_form.password).to eq(password)
      end
    end

    it 'submits the login form'
  end
end
