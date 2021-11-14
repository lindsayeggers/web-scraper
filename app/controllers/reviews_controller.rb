# frozen_string_literal: true

class ReviewsController < ApplicationController

  def collect
    scraper = Scraper.new(url_param, page_param)
    data = scraper.process
    if data
      render json: data
    else
      render json: { errors: scraper.errors }, status: :unprocessable_entity
    end
  end

  private

  def url_param
    params["url"]
  end

  def page_param
    params["page"].presence || "1"
  end

end
