# frozen_string_literal: true

FactoryBot.define do
  sequence(:spotify_id) { |n| rand > 0.5 ? "spotify_#{n}" : nil }

  factory :artist do
    sequence(:name) { |n| "Artist #{n}" }
    img_url { 'https://placekitten.com/200/300' }
    spotify_id { generate(:spotify_id) }
    sequence(:discogs_id) do |n|
      if spotify_id.nil?
        "discogs_#{n}"
      else
        rand > 0.5 ? "discogs_#{n}" : nil
      end
    end
    total_tracks { 0 }
    total_albums { 0 }
  end

  factory :genre do
    sequence(:name) { |n| "Genre #{n}" }
    total_albums { 0 }
  end

  factory :style do
    sequence(:name) { |n| "Style #{n}" }
    total_albums { 0 }
  end

  factory :album do
    sequence(:name) { |n| "Album #{n}" }
    sequence(:added_at) { |n| "#{2019 - n}-01-01T00:16:48.000Z" }
    sequence(:release_date) { |n| "#{2016 - n}-01-01" }
    total_tracks { 12 }
    img_url { 'https://placekitten.com/200/300' }
    img_width { 200 }
    img_height { 300 }
    spotify_id { generate(:spotify_id) }
    sequence(:discogs_id) do |n|
      if spotify_id.nil?
        "discogs_#{n}"
      else
        rand > 0.5 ? "discogs_#{n}" : nil
      end
    end

    transient do
      artists_count { rand(1..3) }
      genres_count { rand(1..3) }
      styles_count { rand(1..3) }
    end

    after(:create) do |album, evaluator|
      create_list(:artist, evaluator.artists_count, albums: [album], total_tracks: album.total_tracks, total_albums: 1)
      create_list(:genre, evaluator.genres_count, albums: [album], total_albums: 1)
      create_list(:style, evaluator.styles_count, albums: [album], total_albums: 1)
    end
  end

  factory :user do
    sequence(:email) { |n| "user-#{n}@test.com" }
    sequence(:username) { |n| "username #{n}" }
    sequence(:password) { |n| "password#{n}" }
    confirmed_at { Time.zone.now }
    role { 'user' }
  end

  factory :batch do
    data { [ create(:album) ] }
    job_id { nil }
  end
end
