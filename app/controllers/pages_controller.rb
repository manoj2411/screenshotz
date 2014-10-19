class PagesController < ApplicationController
  skip_before_filter :authenticate_user!

  def home
    redirect_to new_screenshot_url if user_signed_in?
  end
end
