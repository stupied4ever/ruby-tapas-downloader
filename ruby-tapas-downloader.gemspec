$:.push File.expand_path('../lib', __FILE__)
require 'ruby_tapas_downloader/version'

Gem::Specification.new do |s|
  s.name             = 'ruby-tapas-downloader'
  s.version          = RubyTapasDownloader::VERSION
  s.summary          = 'Downloader for Avdi Grimm Ruby Tapas'
  s.description      = 'It downloads all episodes and attachments, organizes them '\
                         'for later use and keeps an easy to use index of episodes.'

  s.authors          = ['Leandro Facchinetti']
  s.email            = 'ruby-tapas-downloader@leafac.com'
  s.files            = `git ls-files -- {lib,config}/*`.split("\n")
  s.files           += ['License.txt']
  s.test_files       = `git ls-files -- {spec}/*`.split("\n")
  s.extra_rdoc_files = ['README.md']
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f|
    File.basename(f)
  }
  s.homepage         = 'https://github.com/leafac/ruby-tapas-downloader'
  s.license          = 'wtfpl'
  s.require_paths    = ['lib']

  s.add_runtime_dependency 'mechanize', '~> 2.7'
  s.add_runtime_dependency 'user-configurations', '~> 0.0.1'
  s.add_runtime_dependency 'thor', '~> 0.19'

  s.add_development_dependency 'rspec', '~> 2.0'
  s.add_development_dependency 'pry-debugger', '~> 0.2'
end
