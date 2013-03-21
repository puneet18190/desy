namespace :db do

  desc "Performs an ANALYZE"
  task :analyze => :environment do
    ActiveRecord::Base.connection.execute 'ANALYZE'
  end

  # Warning: the config/pepper file must be the same of the one used when passwords are dumped; otherwise
  # users authentication will not work
  desc 'dumps the current database to CSV files for seeding usage'
  task :csv_dump => :environment do
    models_with_columns = {
      Bookmark           => %w( id user_id bookmarkable_id bookmarkable_type ),
      Lesson             => %w( id user_id school_level_id subject_id title description is_public parent_id copied_not_modified token notified ),
      Like               => %w( id lesson_id user_id ),
      Location           => %w( id name sti_type ancestry ),
      MediaElement       => %w( id user_id title description sti_type is_public publication_date ),
      MediaElementsSlide => %w( id media_element_id slide_id position caption alignment ),
      SchoolLevel        => %w( id description ),
      Slide              => %w( id lesson_id title text position kind ),
      Subject            => %w( id description ),
      Tag                => %w( id word ),
      Tagging            => %w( tag_id taggable_id taggable_type ),
      User               => %w( id email name surname school_level_id encrypted_password confirmed location_id active ),
      UsersSubject       => %w( user_id subject_id )
    }
    output_folder = Rails.root.join("db/seeds/environments/#{Rails.env}/csv")

    Dir.mktmpdir do |dir|
      models_with_columns.each do |model, columns|
        FileUtils.chmod 0777, dir
        csv_path = File.join dir, "#{model.table_name}.csv"
        model.connection.execute "COPY ( SELECT #{columns.map{ |c| model.connection.quote_column_name(c) }.join(', ')} 
                                         FROM #{model.quoted_table_name} ORDER BY id
                                       ) TO #{model.quote_value(csv_path.to_s)}
                                       WITH (FORMAT csv, HEADER true)"
      end
      FileUtils.mkdir_p output_folder
      FileUtils.rm_rf output_folder
      FileUtils.cp_r dir, output_folder
    end
  end

  desc "Rebuild database and schemas after a structural change, updating schema.rb, regardless of the configuration"
  task :rebuild => %w( db:drop db:create db:migrate db:seed db:analyze tmp:clear db:test:prepare db:structure:dump db:schema:dump )
  
  desc "empties all notifications"
  task :empty_notifications => :environment do
    Notification.all.each do |l|
      l.destroy
    end
  end
  
  desc "empties your lessons"
  task :empty_dashboard_lessons => :environment do
    Lesson.all.each do |l|
      l.destroy
    end
    Bookmark.where(:bookmarkable_type => 'Lesson', :user_id => 1).each do |b|
      b.destroy
    end
  end
  
  desc "empties your lessons"
  task :empty_lessons => :environment do
    Lesson.where(:user_id => 1).each do |l|
      l.destroy
    end
    Bookmark.where(:bookmarkable_type => 'Lesson', :user_id => 1).each do |b|
      b.destroy
    end
  end
  
  desc "empties dashboard media elements"
  task :empty_dashboard_media_elements => :environment do
    admin = User.admin
    MediaElement.where(:is_public => true).each do |me|
      admin.bookmark 'MediaElement', me.id
    end
  end
  
  desc "empties your media elements"
  task :empty_media_elements => :environment do
    MediaElement.where(:user_id => 1).each do |l|
      l.destroy
    end
    Bookmark.where(:bookmarkable_type => 'MediaElement', :user_id => 1).each do |b|
      b.destroy
    end
  end
  
  desc "Rebuild notifications without re-initializing the database"
  task :notifications => :environment do
    Notification.all.each do |n|
      n.destroy
    end
    notifics = []
    notifics << 'Ma De Rossi a Roma che cosa ci sta a fare quando le cose vanno male è sempre colpa sua'
    notifics << "a daniè t'avevo detto che dovevi annà al city"
    notifics << "共產黨通過「鎮壓反革命」嘅運動，對私有經濟同財產進行城市工商業"
    notifics << "Prova il brivido del Poker online Gioca su StarCasinò. Bonus 1.000€!"
    notifics << "Io i napoletani li conosco benissimo senza la violenza sono gente morta"
    notifics << "CMQ SE DOVESSERO ESSERE STANCHI CI PENSA IL DR.FAJARDO A TIRARLI SU."
    notifics << "La unica cosa certa che c'e' e' che gli juventini e i napoletani sono riusciti a fare odiare la nazionale"
    notifics << "la lazio e' l'unica squadra forte che abbiamo in italia... juventus e napoli si credono real madrid e barcellona "
    notifics << "stai dicendo fregnacce.....taci e meglio,e non condannare prima del tempo."
    notifics << "Uhm e chi sarebbero i giocatori della juve che non han giocato???"
    notifics << "se la pensi cosi è meglio che cambi sport!!!!"
    notifics << "La squadra piu ladra del pianeta rubera' l'ennesimo scudetto ,,,cavolo che soddisfazione !!! "
    notifics << "scommettiamo che la prossima degli azzurri non gioca neanche Pirlo?"
    notifics << "Il fatto che per eliminare l'italia quella partita dovesse finire non solo in un pareggio, ma anche esattamente 2-2, le è sfuggito per caso, mica perchè avrebbe screditato le sue teorie, giusto?"
    notifics << "Irlanda travolta 6-1. Trap: «Non mi dimetto»"
    notifics << "Mou: «Balotelli? Potrei scriverci un romanzo»"
    notifics.each do |n|
      Notification.send_to 1, n
    end
    Notification.limit(10).each do |n|
      n.has_been_seen
    end
  end
  
end