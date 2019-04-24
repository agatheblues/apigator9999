namespace :db do
  desc "Truncate all existing data"
  task truncate: "db:load_config" do
    DatabaseCleaner.clean_with :truncation
  end
end
