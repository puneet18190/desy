namespace :migrations do
  
  desc "rebuild database and schemas after a structural change"
  task :rebuild => :environment do
    Rake::Task["db:drop"].execute
    Rake::Task["db:create"].execute
    Rake::Task["db:migrate"].execute
    Rake::Task["db:seed"].execute
    Rake::Task["db:structure:dump"].execute
  end
  
end
