# Perform Login in Ruby Tapas.
#
# Login must be performed before any attempt to download files.
class RubyTapasDownloader::Login
  # @return [Mechanize] the Mechanize agent.
  attr_reader :agent

  # @return [String] the e-mail for the user.
  attr_reader :email

  # @return [String] the password for the user.
  attr_reader :password

  def initialize(agent, email, password)
    @agent    = agent
    @email    = email
    @password = password
  end

  # Perform login.
  def login
    RubyTapasDownloader.logger.info 'Logging in...'
    request_login_page
    fill_login_form
    submit_login_form
  end

  private

  def request_login_page
    @page = agent.get RubyTapasDownloader::Config.urls.fetch(:login)
  end

  def fill_login_form
    login_form.username = email
    login_form.password = password
  end

  def submit_login_form
    login_form.submit
  end

  def login_form
    @page.forms.first
  end
end
