require 'spec_helper'

describe RubyTapasDownloader::Login do
  subject(:ruby_tapas_downloader) do
    RubyTapasDownloader::Login.new agent, email, password
  end

  let(:agent)    { double get: page }
  let(:email)    { 'someone@example.com' }
  let(:password) { 'chunky bacon' }

  let(:page)       { double forms: [login_form] }
  let(:login_form) do
    double :username= => nil,
           :password= => nil,
           :submit    => nil
  end

  describe '#login' do
    it 'requests the login page' do
      expect(agent).to receive(:get)
                       .with(RubyTapasDownloader::Config.urls.fetch(:login))
      ruby_tapas_downloader.login
    end

    it 'fills in the login form' do
      expect(login_form).to receive(:username=).with(email)
      expect(login_form).to receive(:password=).with(password)
      ruby_tapas_downloader.login
    end

    it 'submits the login form' do
      expect(login_form).to receive(:submit)
      ruby_tapas_downloader.login
    end
  end
end
