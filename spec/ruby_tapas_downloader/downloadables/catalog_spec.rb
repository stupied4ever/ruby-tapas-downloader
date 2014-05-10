describe RubyTapasDownloader::Downloadables::Catalog do
  subject(:catalog) do
    RubyTapasDownloader::Downloadables::Catalog.new episodes
  end

  let(:episodes) { [double(download: true), double(download: true)] }

  specify('#episodes') { expect(catalog.episodes).to eq(episodes) }

  it 'is downloadable' do
    expect(catalog).to be_a RubyTapasDownloader::Downloadable
  end

  describe '#download' do
    subject(:download_catalod) { catalog.download basepath, agent }

    let(:basepath)     { Dir.pwd }
    let(:agent)        { double }

    before { allow(FileUtils).to receive(:mkdir_p) }

    it 'calls #download on each episode' do
      episodes.each do |episode|
        expect(episode).to receive(:download).with(basepath, agent)
      end

      download_catalod
    end

    context 'with invalid download_path' do
      let(:basepath) { '/tmp/some-crazy-folder/you-dont-have-this' }

      specify do
        expect { download_catalod }.to raise_error(
                              RubyTapasDownloader::Exceptions::BadDownloadPath)
      end
    end

    context 'with a file instead of a directory' do
      let(:basepath) { File.absolute_path(__FILE__) }

      specify do
        expect { download_catalod }.to raise_error(
                              RubyTapasDownloader::Exceptions::BadDownloadPath)
      end
    end
  end

  describe '#==' do
    it 'compares episodes' do
      expect(catalog).to eq(
                      RubyTapasDownloader::Downloadables::Catalog.new episodes)
    end
  end

  describe '#eql?' do
    it 'compares episodes' do
      expect(catalog.eql?(
        RubyTapasDownloader::Downloadables::Catalog.new episodes)).to be_truthy
    end
  end

  describe '#hash' do
    it 'is based on episodes' do
      expect(catalog.hash).to eq(episodes.hash)
    end
  end
end
