namespace :exports do
  namespace :lessons do

    namespace :archives do
      
      desc "Remove lesson archives"
      task :clean => :environment do
        require 'export'
        Export::Lesson::Archive.remove_folder!
      end

    end

    namespace :assets do

      def clean
        Export::Lesson::Assets.remove_folder!
      end

      desc "Remove compiled lesson exporting assets"
      task :clean => :environment do
        require 'export'
        clean
      end

      desc "Compile lesson exporting assets"
      task :compile => :environment do
        require 'export'
        clean
        Export::Lesson::Assets.compile
      end

    end

  end
end
