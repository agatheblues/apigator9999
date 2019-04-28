FactoryBot.define do
  sequence :genre_name do |n|
    "genre_#{n}"
  end

  sequence :genre_category do |n|
    rand < 0.5 ? "genre" : "style"
  end

  factory :genre do
    name { generate(:genre_name) }
    category { generate(:genre_category) }
  end
end
