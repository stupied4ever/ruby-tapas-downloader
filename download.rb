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
      self.class.logger.info("Restoring episode index from `#@index_filename'")
      @episodes ||= if File.exists? @index_filename
                      YAML.load(File.read(@index_filename))
                    else
                      {}
                    end
    end

    def dump_episodes
      self.class.logger.info("Dumping episode index in `#@index_filename'")
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
        title = episode_element.search('h3').text
        number = title.match(/\A\s*(\d+)/)
        number = number.nil? ? title.hash : number[1].to_i
        @episodes[number] ||= {
          number:     number,
          title:      title,
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
        if @episodes[number][:files].nil?
          @episodes[number][:files] = extract_episode_files(episode)
          dump_episodes
        end
      }
    end

    def extract_episode_files episode
      self.class.logger.info("Extracting files information for episode `#{ episode[:title] }'")
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
      @episodes.each_value do |episode|
        self.class.logger.info("Downloading files for episode `#{ episode[:title] }'")
        episode[:files].each do |file|
          episode_path = episode_path episode
          FileUtils.mkdir_p(episode_path)
          filename = File.join episode_path, file[:filename]
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
      File.join @episodes_path, episode[:title].parameterize
    end
end

Download.new.start
