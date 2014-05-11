require 'user-configurations'

# Retrieve configurations.
class RubyTapasDownloader::Config
  CONFIG_KEYS = [
    EMAIL         = 'RUBY_TAPAS_DOWNLOADER_EMAIL',
    PASSWORD      = 'RUBY_TAPAS_DOWNLOADER_PASSWORD',
    DOWNLOAD_PATH = 'RUBY_TAPAS_DOWNLOADER_DOWNLOAD_PATH'
  ]

  class << self

    # Retrieve urls stored in `urls.yml`.
    # @return [Hash] the urls stored in `urls.yml`.
    def urls
      @urls ||= YAML.load_file urls_config_path
    end

    # Default Email
    def default_email
      user_configurations[EMAIL]
    end

    # Default Password
    def default_password
      user_configurations[PASSWORD]
    end

    # Default Download path
    def default_download_path
      user_configurations[DOWNLOAD_PATH]
    end

    # Updates user preferences
    def update(email: nil, password: nil, download_path: nil)
      download_path = absolute_path(download_path)

      new_configs = {
        EMAIL => email, PASSWORD => password, DOWNLOAD_PATH => download_path
      }

      user_configurations[EMAIL]         = email
      user_configurations[PASSWORD]      = password
      user_configurations[DOWNLOAD_PATH] = download_path

      user_configurations.store new_configs
    end

    private

    def user_configurations
      @configs ||= UserConfigurations::Configuration.new(
        'ruby-tapas-downloader'
      )
    end

    def absolute_path(path)
      return path if (Pathname.new path).absolute?

      File.expand_path(Dir.pwd, path)
    end

    def urls_config_path
      Pathname File.expand_path('../../../config/urls.yml', __FILE__)
    end
  end
end
