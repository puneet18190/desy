# encoding: UTF-8

namespace :migrations do
  
  desc "Rebuild database and schemas after a structural change, updating both schema.rb and structure.sql, regardless of the configuration"
  task :rebuild => %w(db:drop db:create db:migrate db:seed db:analyze db:test:prepare db:schema:dump)
  
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
    admin = User.find_by_email SETTINGS['admin']['email']
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
