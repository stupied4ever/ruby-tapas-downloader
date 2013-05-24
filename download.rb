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
    @index_filename = File.join(@episodes_path, 'index.yml')
    @pages = {}
  end

  def start
    self.class.logger.info("Starting download")
    retrieve_env_vars!
    restore_episodes!
    login_subscriber
    extract_episodes
    extract_files
    download_files
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

    def restore_episodes!
      self.class.logger.info("Restoring episodes from `#@index_filename'")
      @episodes ||= if File.exists? @index_filename
                      YAML.load(File.read(@index_filename))
                    else
                      {}
                    end
    end

    def dump_episodes
      self.class.logger.info("Dumping episodes in `#@index_filename'")
      FileUtils.mkdir_p File.dirname(@index_filename)
      YAML.dump(@episodes, File.open(@index_filename, 'w')).close
    end

    def login_subscriber
      self.class.logger.info("Logging in subscriber `#@username'")
      @pages[:login] = login_page = @agent.get(MAIN_URL)
      login_form = login_page.form_with(action: %r{\A/subscriber/login})
      login_form.username = @username
      login_form.password = @password
      @pages[:episodes_index] = login_form.submit
    end

    def extract_episodes
      self.class.logger.info("Extracting episodes information")
      episodes_elements = @pages[:episodes_index].search('.blog-entry')
      episodes_elements.each { |episode_element|
        full_title = episode_element.search('h3').text
        _, number, title = full_title.match(/\A\s*(\d+)\s*(\S.*)\z/)
        @episodes[number] ||= {
          number:     number,
          title:      title,
          full_title: full_title,
          post_id:    episode_element.search('a')
                                     .last
                                     .attribute('href')
                                     .value
                                     .match(/id=(\d+)/)[1]
        }
      }
    end

    def extract_files
      @episodes.each { |number, episode|
        @episodes[number][:files] ||= extract_episode_files(episode)
        dump_episodes
      }
    end

    def extract_episode_files episode
      self.class.logger.info("Extracting files information for episode `#{ episode[:full_title] }'")
      @pages[:episodes] ||= {}
      @pages[:episodes][episode[:post_id]] =
        episode_page = @agent.get(episode_url(episode[:post_id]))
      files_link = episode_page.links_with href: %r{\A/subscriber/download}
      files_link.map { |file_link|
        {
          id:       file_link.href.match(/file_id=(\d+)/)[1],
          filename: file_link.text
        }
      }
    end

    def download_files
      @episodes.each do |number, episode|
        self.class.logger.info("Downloading files for episode `#{ episode[:full_title] }'")
        episode[:files].each do |file|
          episode_path = episode_path episode
          filename = File.join episode_path, file[:filename]
          FileUtils.mkdir_p(episode_path)
          if File.exists? filename
            self.class.logger.info("Skipping already existing file `#{ filename }'")
          else
            self.class.logger.info("Start downloading file `#{ filename }'")
            @agent.download file_url(file[:id]), filename
            self.class.logger.info("Finish downloading file `#{ filename }'")
          end
        end
      end
    end

    def episode_url post_id
      "#{ EPISODE_URL }#{ post_id }"
    end

    def file_url id
      "#{ FILE_URL }#{ id }"
    end

    def episode_path episode
      File.join @episodes_path, episode[:full_title].parameterize
    end
end

Download.new.start
