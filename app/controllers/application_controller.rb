class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :basic_auth
  
  def basic_auth
    authenticate_or_request_with_http_basic("Password Please #{ENV['USER']} #{ENV['PASS']}") do |username, password|
      username == ENV['USER'] && password == ENV['PASS']
    end
  end

end
