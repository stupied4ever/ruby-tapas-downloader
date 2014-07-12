require 'spec_helper'

describe RubyTapasDownloader::Downloadable do
  subject(:downloadable) { downloadable_class.new }

  let(:downloadable_class) { Class.new RubyTapasDownloader::Downloadable }

  describe 'contract' do
    specify('#download') do
      expect { downloadable.download }.to raise_error NotImplementedError
    end
  end
end
