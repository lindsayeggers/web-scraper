# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scraper do
  subject(:review_spider) { described_class.new(url, page) }

  describe "#process" do
    let(:url) { "http://www.example.com" }
    let(:page) { "1" }

    context "when page number is invalid" do
      let(:page) { "0" }

      it "returns false" do
        expect(review_spider.process).to eq false
      end
    end

    context "when url is invalid" do
      let(:url) { "foo" }

      it "returns false" do
        expect(review_spider.process).to eq false
      end
    end

    context "when required review attributes are missing" do
      let(:stubbed_response) { Rails.root.join("spec", "fixtures", "invalid_html_response.rb") }

      # rubocop:disable RSpec/AnyInstance
      before do
        allow_any_instance_of(Request).to receive(:process).and_return(stubbed_response)
      end
      # rubocop:enable RSpec/AnyInstance

      it "returns false" do
        expect(review_spider.process).to eq false
      end

      it "does not save Reviews" do
        expect { review_spider.process }.to change(Review, :count).by(0)
      end
    end

    context "when happy path is used" do
      let(:stubbed_response) { Rails.root.join("spec", "fixtures", "html_response.rb") }
      # rubocop:disable Layout/LineLength
      let(:output) do
        [
          {
            author: "Marcus",
            city: "Kyle",
            closed_with_lender: true,
            content: "I was in a real bad spot and Upstart provided me a way out of my situation without needing collateral.  I will forever be grateful.  Thank you so much. ",
            date: "2021-11-01",
            recommended: true,
            star_rating: "5",
            state: "TX",
            title: "Help when needed",
          },
          {
            author: "Russell",
            city: "Cortland",
            closed_with_lender: true,
            content: "The entire process was so easy from the comfort of home! I was so pleased that approval took seconds, funding was available and had to wait only 24 hours before funds were available directly deposited in my account the next day!",
            date: "2021-11-01",
            recommended: true,
            star_rating: "5",
            state: "NY",
            title: "Great Experience",
          },
        ]
      end
      # rubocop:enable Layout/LineLength

      # rubocop:disable RSpec/AnyInstance
      before do
        allow_any_instance_of(Request).to receive(:process).and_return(stubbed_response)
      end
      # rubocop:enable RSpec/AnyInstance

      it "saves Reviews" do
        expect { review_spider.process }.to change(Review, :count).by(2)
      end

    end
  end
end
