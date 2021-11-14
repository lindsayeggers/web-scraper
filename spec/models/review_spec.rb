# frozen_string_literal: true

require "rails_helper"

RSpec.describe Review, type: :model do
  subject(:review) { build(:review) }

  it { is_expected.to validate_presence_of(:author) }
  it { is_expected.to validate_presence_of(:star_rating) }
  it { is_expected.to validate_presence_of(:date) }
end

# == Schema Information
#
# Table name: reviews
#
#  id                 :uuid             not null, primary key
#  author             :string           not null
#  city               :string
#  closed_with_lender :boolean
#  content            :string
#  date               :date             not null
#  recommended        :boolean
#  star_rating        :integer          not null
#  state              :string
#  title              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
