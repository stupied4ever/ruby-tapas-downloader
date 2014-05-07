module RubyTapasDownloader
  # Handle RubyTapasDownloader params
  class Params

    CONFIG_KEYS = [
      EMAIL    = 'RUBY_TAPAS_DOWNLOADER_USER',
      PASSWORD = 'RUBY_TAPAS_DOWNLOADER_PASSWORD',
      PATH     = 'RUBY_TAPAS_DOWNLOADER_PATH'
    ]

    def initialize(params)
      @params = params
    end

    # User
    def email
      params[EMAIL]
    end

    # Password
    def password
      params[PASSWORD]
    end

    # Download path
    def path
      params[PATH]
    end

    protected

    attr_reader :params
  end
end
