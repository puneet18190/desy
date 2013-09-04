namespace :exports do
  namespace :lessons do

    namespace :archives do
      
      desc "Remove lesson archives and public links"
      task :clean => :environment do
        require 'export'
        Export::Lesson::Archive.remove_folder!
        Export::Lesson::Archive.remove_public_folder!
      end

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
        Export::Lesson::Assets.remove_folder!
      end

      desc "Remove compiled lesson exporting assets"
      task :clean => :environment do
        require 'export/lesson/assets'
        clean
      end

      desc "Compile lesson exporting assets"
      task :compile => :environment do
        continue_or_reboot_rake_task 'exports:lessons:assets:compile'

        require 'export/lesson/assets'
        Export::Lesson::Assets.compile
      end

      desc "Clean and compile lesson exporting assets"
      task :recompile => :environment do
        require 'export/lesson/assets'
        clean
        invoke_or_reboot_rake_task 'exports:lessons:assets:compile'
      end

    end

  end
end
