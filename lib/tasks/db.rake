namespace :db do

  desc "Performs an ANALYZE"
  task :analyze => :environment do

    ActiveRecord::Base.connection.execute 'ANALYZE'

  end
end