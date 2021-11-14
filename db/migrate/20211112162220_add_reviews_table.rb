# frozen_string_literal: true

class AddReviewsTable < ActiveRecord::Migration[6.1]
  def change
    enable_extension "pgcrypto"

    create_table :reviews, id: :uuid do |t|\
      t.string :title
      t.string :author, null: false
      t.string :content
      t.string :city
      t.string :state
      t.integer :star_rating, null: false
      t.boolean :recommended
      t.boolean :closed_with_lender
      t.date :date, null: false
      t.timestamps
    end
  end
end
