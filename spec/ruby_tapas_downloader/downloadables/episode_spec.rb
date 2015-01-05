describe RubyTapasDownloader::Downloadables::Episode do
  subject(:episode) do
    RubyTapasDownloader::Downloadables::Episode.new title, link, files
  end

  let(:files) { [first_file, second_file] }

  let(:first_file) do
    instance_double(
      RubyTapasDownloader::Downloadables::File, download: true, name: 'first'
    )
  end

  let(:second_file) do
    instance_double(
      RubyTapasDownloader::Downloadables::File, download: true, name: 'second'
    )
  end

  let(:title)           { '999 Some: Ruby Tapas Episode with <<' }
  let(:link)            { 'http://example.com' }
  let(:sanitized_title) { '999-some-ruby-tapas-episode-with-' }

  specify('#title') { expect(episode.title).to eq(title) }
  specify('#link') { expect(episode.link).to eq(link) }
  specify('#files') { expect(episode.files).to eq(files) }
  specify '#sanitized_title' do
    expect(episode.sanitized_title).to eq(sanitized_title)
  end

  it 'is downloadable' do
    expect(episode).to be_a RubyTapasDownloader::Downloadable
  end

  describe '#already_downloaded?' do
    subject(:already_downloaded?) { episode.already_downloaded? basepath }

    let(:basepath) { '/tmp/ruby-tapas' }

    before do
      allow(File).to receive(:exist?).with(first_file_name).and_return(false)
      allow(File).to receive(:exist?).with(second_file_name).and_return(false)
    end

    let(:first_file_name) { File.join(basepath, first_file.name) }
    let(:second_file_name) { File.join(basepath, second_file.name) }

    it { expect(already_downloaded?).to be_falsy }

    context 'when all the files has been downloaded' do
      before do
        allow(File).to receive(:exist?).with(first_file_name).and_return(true)
        allow(File).to receive(:exist?).with(second_file_name).and_return(true)
      end

      it { expect(already_downloaded?).to be_truthy }
    end

    context 'when some of the files has not been downloaded' do
      it { expect(already_downloaded?).to be_falsy }
    end
  end

  describe '#download' do
    let(:basepath)     { '/tmp/ruby-tapas' }
    let(:agent)        { instance_double(Mechanize) }
    let(:episode_path) { File.join basepath, sanitized_title }

    before { allow(FileUtils).to receive(:mkdir_p) }

    it "checks if it's an `already_downloaded?` eposide" do
      expect(episode).to receive(:already_downloaded?).with(episode_path)

      episode.download basepath, agent
    end

    it 'creates folder for episode with sanitized title' do
      expect(FileUtils).to receive(:mkdir_p).with(episode_path)

      episode.download basepath, agent
    end

    it 'calls #download on each file' do
      files.each do |file|
        expect(file).to receive(:download).with(episode_path, agent)
      end

      episode.download basepath, agent
    end

    context 'an already downloaded episode' do
      before do
        allow(episode).to receive(:already_downloaded?).and_return(true)
      end

      it 'does not create folder for episode' do
        expect(FileUtils).to_not receive(:mkdir_p)

        episode.download basepath, agent
      end

      it 'does not call  #download on each file' do
        files.each do |file|
          expect(file).to_not receive(:download)
        end

        episode.download basepath, agent
      end
    end
  end

  describe '#==' do
    it 'compares title, link and files' do
      expect(episode).to eq(
           RubyTapasDownloader::Downloadables::Episode.new title, link, files)
    end
  end

  describe '#eql?' do
    it 'compares title, link and files' do
      expect(
        episode.eql?(
          RubyTapasDownloader::Downloadables::Episode.new title, link, files)
      ).to be_truthy
    end
  end

  describe '#hash' do
    it 'is based on title, link and files' do
      expect(episode.hash).to eq(title.hash + link.hash + files.hash)
    end
  end
end
