# frozen_string_literal: true

class SearchController < ApplicationController
  def new
    @q = Section.ransack(params[:q]) # Initialize the Ransack object
  end
end
