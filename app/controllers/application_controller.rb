class ApplicationController < ActionController::Base
  def html_title
    "#{"{DEV}" if Rails.env.development?} Enough Email"
  end

  helper_method :html_title
end
