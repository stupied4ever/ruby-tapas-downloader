class RubyTapasDownloader::Login
  attr_reader :agent
  attr_reader :email
  attr_reader :password

  def initialize agent, email, password
    @agent    = agent
    @email    = email
    @password = password
  end

  def perform
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
