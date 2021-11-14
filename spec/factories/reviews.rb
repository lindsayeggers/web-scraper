# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    author { Faker::Name.first_name }
    title { Faker::Movie.title }
    content { Faker::Movie.quote }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    star_rating { Faker::Number.between(from: 1, to: 5) }
    recommended { true }
    closed_with_lender { true }
    date { 1.month.ago }
  end
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
