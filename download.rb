require 'mechanize'
require 'active_support/core_ext/string/inflections'
require 'logger'
require 'yaml'

class Download
  MAIN_URL    = 'https://rubytapas.dpdcart.com/subscriber/content'
  EPISODE_URL = 'https://rubytapas.dpdcart.com/subscriber/post?id='
  FILE_URL    = 'https://rubytapas.dpdcart.com/subscriber/download?file_id='

  def initialize(episodes_path = 'episodes')
    @episodes_path = episodes_path
    @agent = Mechanize.new
    @agent.log = self.class.logger
  end

  def start
    self.class.logger.info("Starting download")
    retrieve_env_vars!
    episodes_page        = login_subscriber
    episodes_information = extract_episodes_information episodes_page
    episodes_information = extract_files_information episodes_information
    dump episodes_information
    download_files episodes_information
    self.class.logger.info("Finished download")
  end

  class << self
    attr_writer :logger
    def logger
      @logger ||= Logger.new(STDOUT).tap { |logger|
        logger.level = ENV['VERBOSE'] == 'true' ? Logger::DEBUG : Logger::INFO
      }
    end
  end

  private
    def retrieve_env_vars!
      @username = ENV['USERNAME']
      @password = ENV['PASSWORD']
      if @username.nil? || @password.nil?
        self.class.logger.fatal("Set `USERNAME' and `PASSWORD' environment variables.")
        exit 1
      end
    end

    def login_subscriber
      self.class.logger.info("Logging in subscriber `#@username'")
      login_page = @agent.get(MAIN_URL)
      login_form = login_page.form_with(action: %r{\A/subscriber/login})
      login_form.username = @username
      login_form.password = @password
      login_form.submit
    end

    def extract_episodes_information episodes_page
      self.class.logger.info("Extracting episodes information")
      episodes_elements = episodes_page.search('.blog-entry')
      episodes_elements.map { |episode_element|
        {
          title: episode_element.search('h3').text,
          id:    episode_element.search('a')
                                .last
                                .attribute('href')
                                .value
                                .match(/id=(\d+)/)[1]
        }
      }
    end

    def extract_files_information episodes_information
      episodes_information.reduce([]) { |files_information, episode_information|
        files_information << episode_information.dup.merge({
          files: extract_single_episode_files_information(episode_information)
        })
        dump files_information
      }
    end

    def extract_single_episode_files_information episode_information
      self.class.logger.info("Extracting files information for episode `#{ episode_information[:title] }'")
      episode_page = @agent.get(episode_url(episode_information[:id]))
      files_link = episode_page.links_with href: %r{\A/subscriber/download}
      files_link.map { |file_link|
        {
          filename: file_link.text,
          id:       file_link.href.match(/file_id=(\d+)/)[1]
        }
      }
    end

    def download_files episodes
      episodes.each do |episode|
        self.class.logger.info("Downloading files for episode `#{ episode[:title] }'")
        episode[:files].each do |file|
          file_path          = File.join @episodes_path,
                                         file[:filename].parameterize
          complete_filename  = File.join file_path, file[:filename]
          FileUtils.mkdir_p(file_path) unless Dir.exists? file_path
          if File.exists? complete_filename
            self.class.logger.info("Skipping already existing file `#{ complete_filename }'")
          else
            self.class.logger.info("Start downloading file `#{ complete_filename }'")
            @agent.download file_url(file[:id]), complete_filename
            self.class.logger.info("Finish downloading file `#{ complete_filename }'")
          end
        end
      end
    end

    def dump data, filename = File.join(@episodes_path, 'index.yml')
      self.class.logger.info("Dumping data in `#{ filename }'")
      dirname = File.dirname filename
      FileUtils.mkdir_p dirname unless Dir.exists? dirname
      YAML.dump(episode_information, File.open(filename, 'w')).close
      data
    end

    def episode_url id
      "#{ EPISODE_URL }#{ id }"
    end

    def file_url id
      "#{ FILE_URL }#{ id }"
    end
end

Download.new.start
