# frozen_string_literal: true

class Scraper

  include ActiveModel::Validations

  attr_reader :page, :url

  validates :page, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp, allow_blank: true }
  validates :url, presence: true

  def initialize(url, page)
    @url = url
    @page = page
  end

  def process
    return false unless valid?

    begin
      response = Request.new(url, page).process
    rescue Errno::ECONNREFUSED, SocketError => e
      errors.add(:base, e.message)
      return false
    end

    reviews = Nokogiri::HTML(response)

    build_reviews(reviews)
  end

  private

  def build_reviews(reviews)
    data = []
    reviews.css(".mainReviews").each do |review|
      scraped_review = scrape(review)
      data << scraped_review
    end
    save_reviews(data)
  end

  # rubocop:disable Metrics/AbcSize
  def scrape(review)
    location = review.css(".consumerName").text.split("from ").last.split(",  ")
    {
      title: review.css(".reviewTitle").text,
      content: review.css(".reviewText").text,
      author: review.css(".consumerName").text.split.first,
      city: location.first,
      state: location.last,
      star_rating: review.css(".numRec").text.chars.second,
      recommended: review.css(".lenderRec").present?,
      closed_with_lender: review.css(".yes").present?,
      date: review.css(".consumerReviewDate").text.split("Reviewed in ").last.to_date,
    }
  end
  # rubocop:enable Metrics/AbcSize

  def save_reviews(reviews)
    Review.transaction do
      reviews.each do |review|
        Review.create!(review)
      end
      { data: reviews }
    end
  rescue ActiveRecord::ActiveRecordError => e
    errors.add(:base, e.message)
    false
  end

end
