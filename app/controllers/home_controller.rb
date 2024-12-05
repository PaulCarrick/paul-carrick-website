# app/controllers/home_controller
# frozen_string_literal: true

include HtmlSanitizer

class HomeController < ApplicationController
  def index
    redirect_to page_path("home")
  end
end
