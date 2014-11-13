describe RubyTapasDownloader::Downloadable do
  subject(:downloadable) { downloadable_class.new }

  let(:downloadable_class) { Class.new RubyTapasDownloader::Downloadable }

  describe 'contract' do
    let(:base_path) {}
    let(:agent) {}

    specify('#download') do
      expect { downloadable.download base_path, agent }
        .to raise_error NotImplementedError
    end
  end
end
