namespace :exports do
  namespace :lessons do
    
#    desc "Cleans and recompiles all the types of lesson download"
#    task :reset => [ # TODO AL MOMENTO NON FUNZIONA, a causa del require che va inserito ancora
#      'exports:lessons:archives:clean',
#      'exports:lessons:archives:assets:recompile',
#      'exports:lessons:scorms:clean',
#      'exports:lessons:scorms:assets:recompile'
#    ]
    
    namespace :archives do
      
      desc "Remove lesson archives"
      task :clean => :environment do
        require 'export'
        Export::Lesson::Archive.remove_folder!
      end

      namespace :assets do

        def ruby_rake_task(task, fork = true)
          groups = ENV['RAILS_GROUPS'] || 'assets'
          args   = [$0, task,"RAILS_GROUPS=#{groups}"]
          args << "--trace" if Rake.application.options.trace
          if $0 =~ /rake\.bat\Z/i
            Kernel.exec $0, *args
          else
            fork ? ruby(*args) : Kernel.exec(FileUtils::RUBY, *args)
          end
          exit
        end

        def continue_or_reboot_rake_task(task)
          if ENV['RAILS_GROUPS'].to_s.empty?
            ruby_rake_task task
          end
        end

        def clean
          Export::Lesson::Archive::Assets.remove_folder!
        end

        desc "Remove compiled lesson exporting assets"
        task :clean => :environment do
          require 'export/lesson/archive/assets'
          clean
        end

        desc "Compile lesson exporting assets"
        task :compile => :environment do
          continue_or_reboot_rake_task 'exports:lessons:archives:assets:compile'

          require 'export/lesson/archive/assets'
          Export::Lesson::Archive::Assets.compile
        end

        desc "Clean and compile lesson exporting assets"
        task :recompile => :environment do
          require 'export/lesson/archive/assets'
          clean
          invoke_or_reboot_rake_task 'exports:lessons:archives:assets:compile'
        end

      end

    end
    
    
    namespace :scorms do
      
      desc "Remove lesson scorms"
      task :clean => :environment do
        require 'export'
        Export::Lesson::Scorm.remove_folder!
      end

      namespace :assets do

        def ruby_rake_task(task, fork = true)
          groups = ENV['RAILS_GROUPS'] || 'assets'
          args   = [$0, task,"RAILS_GROUPS=#{groups}"]
          args << "--trace" if Rake.application.options.trace
          if $0 =~ /rake\.bat\Z/i
            Kernel.exec $0, *args
          else
            fork ? ruby(*args) : Kernel.exec(FileUtils::RUBY, *args)
          end
          exit
        end

        def continue_or_reboot_rake_task(task)
          if ENV['RAILS_GROUPS'].to_s.empty?
            ruby_rake_task task
          end
        end

        def clean
          Export::Lesson::Scorm::Assets.remove_folder!
        end

        desc "Remove compiled lesson exporting assets for scorm"
        task :clean => :environment do
          require 'export/lesson/scorm/assets'
          clean
        end

        desc "Compile lesson exporting assets for scorm"
        task :compile => :environment do
          continue_or_reboot_rake_task 'exports:lessons:scorms:assets:compile'

          require 'export/lesson/scorm/assets'
          Export::Lesson::Scorm::Assets.compile
        end

        desc "Clean and compile lesson exporting assets for scorm"
        task :recompile => :environment do
          require 'export/lesson/scorm/assets'
          clean
          invoke_or_reboot_rake_task 'exports:lessons:scorms:assets:compile'
        end

      end

    end
    
    
    namespace :ebooks do
      
      desc "Remove lesson ebooks"
      task :clean => :environment do
        require 'export'
        Export::Lesson::Ebook.remove_folder!
      end

    end
  end
end
