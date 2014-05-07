require 'spec_helper'

module RubyTapasDownloader
  describe Params do
    subject(:params) { described_class.new(args) }

    let(:args) do
      {
        Params::EMAIL    => 'eusou@rafaelalmeida.net',
        Params::PASSWORD => 'p@$$w0rd!',
        Params::PATH     => '.'
      }
    end

    describe '#email' do
      it { expect(params.email).to eq('eusou@rafaelalmeida.net') }
    end

    describe '#password' do
      it { expect(params.password).to eq('p@$$w0rd!') }
    end

    describe '#download_path' do
      it { expect(params.path).to eq('.') }
    end
  end
end
