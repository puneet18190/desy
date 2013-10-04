# clear the doc:app task et al so we can rewrite them
Rake::Task["db:reset"].clear
Rake::Task["db:setup"].clear

namespace :db do

  desc "Load structure and seed"
  task :load_structure_and_seed => %w( db:structure:load db:seed )

  desc "Performs an ANALYZE"
  task :analyze => :environment do
    ActiveRecord::Base.connection.execute 'ANALYZE'
  end

  # Warning: the config/pepper file must be the same of the one used when passwords are dumped; otherwise
  # users authentication will not work
  # FIXME BROKEN!!! should be updated in order to add the duration columns to media_elements.csv
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

  desc "Create the database, load the schema, and initialize with the seed data (use db:reset to also drop the db first)"
  task :setup => %w( db:create db:structure:load db:seed db:analyze )
  
  desc "Recreate the database, load the schema, and initialize with the seed data"
  task :reset => %w( db:drop db:setup )

  desc "Rebuild database and schemas after a structural change, updating schema.rb, regardless of the configuration"
  task :rebuild => %w( db:drop db:create db:migrate db:seed db:analyze tmp:clear db:test:prepare db:structure:dump db:schema:dump )

  desc "empties all notifications"
  task :empty_notifications => :environment do
    Notification.all.each do |r|
      r.destroy
    end
  end
  
  desc "empties your lessons"
  task :empty_dashboard_lessons => :environment do
    Lesson.all.each do |r|
      r.destroy
    end
    Bookmark.where(:bookmarkable_type => 'Lesson', :user_id => 1).each do |r|
      r.destroy
    end
  end
  
  desc "empties your lessons"
  task :empty_lessons => :environment do
    Lesson.where(:user_id => 1).each do |r|
      r.destroy
    end
    Bookmark.where(:bookmarkable_type => 'Lesson', :user_id => 1).each do |r|
      r.destroy
    end
  end
  
  desc "empties dashboard media elements"
  task :empty_dashboard_media_elements => :environment do
    admin = User.admin
    MediaElement.where(:is_public => true).each do |r|
      admin.bookmark 'MediaElement', r.id
    end
  end
  
  desc "empties your media elements"
  task :empty_media_elements => :environment do
    MediaElement.where(:user_id => 1).each do |r|
      r.destroy
    end
    Bookmark.where(:bookmarkable_type => 'MediaElement', :user_id => 1).each do |r|
      r.destroy
    end
  end
  
  desc "Rebuild notifications without re-initializing the database"
  task :notifications => :environment do
    an_user_id = User.admin.id
    Notification.delete_all
    Notification.send_to an_user_id, I18n.t('notifications.lessons.destroyed', :user_name => 'Luciano Moggi', :lesson_title => 'Gelato al cioccolato')
    Notification.send_to an_user_id, I18n.t('notifications.lessons.link_sent', :title => 'Gelato al cioccolato', :message => 'Guardate che bella lezione!', :emails => 'moggi@figc.it, carraro@figc.it')
    Notification.send_to an_user_id, I18n.t('notifications.lessons.modified', :lesson_title => 'Gelato al cioccolato', :message => 'Ho aggiornato le ultime slides', :link => 'www.google.com')
    Notification.send_to an_user_id, I18n.t('notifications.lessons.unpublished', :user_name => 'Luciano Moggi', :lesson_title => 'Gelato al cioccolato')
    Notification.send_to an_user_id, I18n.t('notifications.audio.compose.update.started', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, I18n.t('notifications.audio.compose.update.ok', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, I18n.t('notifications.audio.compose.update.failed', :item => 'Gelato al cioccolato', :link => 'www.google.com')
    Notification.send_to an_user_id, I18n.t('notifications.audio.compose.create.started', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, I18n.t('notifications.audio.compose.create.ok', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, I18n.t('notifications.audio.compose.create.failed', :item => 'Gelato al cioccolato', :link => 'www.google.com')
    Notification.send_to an_user_id, I18n.t('notifications.audio.upload.started', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, I18n.t('notifications.audio.upload.ok', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, I18n.t('notifications.audio.upload.failed', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, I18n.t('notifications.video.compose.update.started', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, I18n.t('notifications.video.compose.update.ok', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, I18n.t('notifications.video.compose.update.failed', :item => 'Gelato al cioccolato', :link => 'www.google.com')
    Notification.send_to an_user_id, I18n.t('notifications.video.compose.create.started', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, I18n.t('notifications.video.compose.create.ok', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, I18n.t('notifications.video.compose.create.failed', :item => 'Gelato al cioccolato', :link => 'www.google.com')
    Notification.send_to an_user_id, I18n.t('notifications.video.upload.started', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, I18n.t('notifications.video.upload.ok', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, I18n.t('notifications.video.upload.failed', :item => 'Gelato al cioccolato')
    Notification.send_to an_user_id, I18n.t('notifications.documents.destroyed', :document_title => 'La seconda guerra mondiale', :lesson_title => 'Gelato al cioccolato', :link => 'www.google.com')
  end
  
end
