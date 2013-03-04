namespace :db do

  desc "Performs an ANALYZE"
  task :analyze => :environment do
    ActiveRecord::Base.connection.execute 'ANALYZE'
  end

  task :csv_dump => :environment do
    models_with_fields = {
      Location     => %w( id name sti_type ancestry ),
      SchoolLevel  => %w( id description ),
      Subject      => %w( id description ),
      User         => %w( id email name surname school_level_id encrypted_password confirmed location_id active ),
      MediaElement => %w( id user_id title description sti_type is_public publication_date )
    }
    models = [ Location, SchoolLevel, Subject, User, MediaElement, Lesson, Slide, MediaElementsSlide, Like, Bookmark ]

    Dir.mktmpdir do |dir|
      models.each do |model|
        csv_path = File.join dir, "#{model.table_name}.csv"
        model.connection.execute "COPY #{model.quoted_table_name} "
      end
    end
  end
  
end