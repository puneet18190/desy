namespace :migrations do
  
  desc "Rebuild database and schemas after a structural change, updating both schema.rb and structure.sql, regardless of the configuration"
  task :rebuild => :environment do
    Rake::Task["db:drop"].execute
    Rake::Task["db:create"].execute
    Rake::Task["db:migrate"].execute
    Rake::Task["db:seed"].execute
    Rake::Task["db:structure:dump"].execute
    Rake::Task["db:schema:dump"].execute
  end
  
end
