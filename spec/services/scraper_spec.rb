# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scraper do
  subject(:review_spider) { described_class.new(url, page) }

  describe "#process" do
    context "when page number is invalid" do
      let(:url) { "http://www.example.com" }
      let(:page) { "0" }

      it "returns false" do
        expect(review_spider.process).to eq false
      end
    end

    context "when url is invalid" do
      let(:url) { "foo" }
      let(:page) { "1" }

      it "returns false" do
        expect(review_spider.process).to eq false
      end
    end
  end
end
