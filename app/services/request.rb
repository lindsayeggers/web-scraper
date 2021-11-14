# frozen_string_literal: true

class Request

  attr_reader :page, :url

  def initialize(url, page)
    @url = url
    @page = page
  end

  def process
    HTTParty.get(url, query: { "pid" => page }).body
  end

end
