require 'fileutils'
require 'pathname'
require 'uri'

require 'sprockets'

require 'export'
require 'export/lesson'

module Export
  module Lesson
    class Assets

      FOLDER = Rails.root.join 'app', 'exports', 'lessons', 'assets'

      def self.remove_folder!
        FileUtils.rm_rf FOLDER
      end

      def self.compiled?
        new.compiled?
      end

      def self.compile
        new.compile
      end

      def compiled?
        FOLDER.exist? && !FOLDER.entries.empty?
      end

      def compile
        FOLDER.rmtree if FOLDER.exist?
        FOLDER.mkpath

        env.each_logical_path(paths) do |logical_path|
          if asset = env.find_asset(logical_path)
            write_asset(asset)
          end
        end
      end

      private

      def write_asset(asset)
        asset.logical_path.tap do |path|
          filename = File.join FOLDER, path
          FileUtils.mkdir_p File.dirname filename
          asset.write_to(filename)
        end
      end

      def env
        @env ||= begin
          assets = Sprockets::Environment.new Rails.root.to_s

          Rails.application.assets.paths.each { |v| assets.append_path v }

          assets.context_class.instance_eval do
            include Sprockets::Helpers::IsolatedHelper
            include Sprockets::Helpers::RailsHelper
          end

          assets.context_class.class_eval do

            def pathname_nestings
              nesting = 0
              @pathname.ascend do |v| 
                break if v.to_s.in? Rails.application.config.assets.paths
                nesting += 1
              end
              nesting
            end

            def asset_path_upfolders
              @asset_path_upfolders ||= {}
              @asset_path_upfolders[@pathname] ||= (['..'] * pathname_nestings).join('/')
            end

            def asset_path(source, options = {})
              URI.escape "#{asset_path_upfolders}/assets/#{source}"
            end
          end

          assets.context_class.instance_eval do
            def sass_config
              Rails.application.assets.context_class.sass_config
            end
          end

          assets
        end
      end

      def paths
        @paths ||= [
          ->(path) { !File.extname(path).in?(['.js', '.css']) } ,
          /(?:\/|\\|\A)application\.(css|js)$/                  ,
          'browser_not_supported/application.css'               ,
          'browser_not_supported/application.js'
        ]
      end
      
    end
  end
end