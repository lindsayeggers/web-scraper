# frozen_string_literal: true

class Review < ApplicationRecord

  validates :author, :star_rating, :date, presence: true

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
