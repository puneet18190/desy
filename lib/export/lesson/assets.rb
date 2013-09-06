require 'fileutils'
require 'pathname'
require 'uri'

require 'sprockets'

require 'export'
require 'export/lesson'

module Export
  module Lesson
    class Assets

      FOLDER = ASSETS_FOLDER

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

          bootstrap(assets)

          assets
        end
      end

      def paths
        @paths ||= %W(
          documents/doc.svg
          documents/exc.svg
          documents/pdf.svg
          documents/ppt.svg
          documents/unknown.svg
          documents/zip.svg
          placeholders/audio_lesson_viewer.gif
          placeholders/video_lesson_viewer_big.gif
          placeholders/video_lesson_viewer_small.gif
          bg_tile_editor.gif
          documents_fondo.png
          favicon32x32.png
          icone-player.svg
          icon_share.png
          icon_share_roll.png
          logo_facebook.png
          logo_facebook_on.png
          logo_google_plus.png
          logo_google_plus_on.png
          logo_twitter.png
          logo_twitter_on.png
          nav_left.png
          nav_right.png
          pallino.svg
          set-icone-editor.svg
          tendina_share.png
          tiny_items.gif
          lesson_export/application.css
          lesson_export/application.js
          browser_not_supported/application.css
          browser_not_supported/application.js
        )
      end
      
      def bootstrap(assets)
        config = Rails.application.config
        if config.assets.compress
          # temporarily hardcode default JS compressor to uglify. Soon, it will work
          # the same as SCSS, where a default plugin sets the default.
          unless config.assets.js_compressor == false
            assets.js_compressor = Sprockets::LazyCompressor.new { Sprockets::Compressors.registered_js_compressor(config.assets.js_compressor || :uglifier) }
          end

          unless config.assets.css_compressor == false
            assets.css_compressor = Sprockets::LazyCompressor.new { Sprockets::Compressors.registered_css_compressor(config.assets.css_compressor) }
          end
        end
      end

    end
  end
end
