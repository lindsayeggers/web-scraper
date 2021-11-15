# frozen_string_literal: true

require "rails_helper"
RSpec.describe "ReviewsRequest", type: :request do
  describe "#collect" do
    let(:stubbed_response) { Rails.root.join("spec", "fixtures", "html_response.html") }

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
        }.stringify_keys,
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
        }.stringify_keys,
      ]
    end
    # rubocop:enable Layout/LineLength

    let(:request_params) { { url: "http://www.example.com", page: "1" } }

    context "with valid params" do
      # rubocop:disable RSpec/AnyInstance
      before do
        allow_any_instance_of(Request).to receive(:process).and_return(stubbed_response)

        post reviews_collect_path(request_params)
      end
      # rubocop:enable RSpec/AnyInstance

      it "returns an 'ok' (200) http status" do
        expect(response).to have_http_status(:ok)
      end

      it "has a JSON content type" do
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "returns review data" do
        expect(JSON.parse(response.body).fetch("data")).to eq(output)
      end
    end

    context "with invalid page param" do
      before { post reviews_collect_path(request_params) }

      let(:request_params) { { url: "http://www.example.com", page: "0" } }

      it "returns an 'unprocessable_entity' (422) http status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "has a JSON content type" do
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "returns the error(s)" do
        expect(JSON.parse(response.body).fetch("errors")).to eq({ "page" => ["must be greater than or equal to 1"] })
      end
    end

    context "with invalid url param" do
      before { post reviews_collect_path(request_params) }

      let(:request_params) { { url: "foo", page: "1" } }

      it "returns an 'unprocessable_entity' (422) http status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "has a JSON content type" do
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "returns the error(s)" do
        expect(JSON.parse(response.body).fetch("errors")).to eq({ "url" => ["is invalid"] })
      end
    end
  end
end
