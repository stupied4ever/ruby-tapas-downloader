require 'spec_helper'

describe RubyTapasDownloader::Downloadable do
  subject(:downloadable) { downloadable_class.new }

  let(:downloadable_class) {
    Class.new do
      include RubyTapasDownloader::Downloadable
    end
  }

  describe 'contract' do
    specify('#download') {
      expect { downloadable.download }.to raise_error NotImplementedError
    }
  end
end
