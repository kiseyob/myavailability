class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :allow_iframe_requests, :set_default_headers

  def initialize
    super()
    @app_name = "My Availability"
  end

  def allow_iframe_requests
	  response.headers.delete('X-Frame-Options')
	end

  def set_default_headers
    response.headers["X-UA-Compatible"] = "IE=edge"
  end
end
