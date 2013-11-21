require 'fileutils'
require 'pathname'
require 'uri'

require 'sprockets'

require 'export'

module Export
  class Assets

    def self.folder
      self::FOLDER
    end

    def self.remove_folder!
      FileUtils.rm_rf folder
    end

    def self.compiled?
      new.compiled?
    end

    def self.compile
      new.compile
    end

    def folder
      self.class.folder
    end

    def compiled?
      folder.exist? && folder.entries.present?
    end

    def compile
      folder.rmtree if folder.exist?
      folder.mkpath

      env.each_logical_path(paths) do |logical_path|
        if asset = env.find_asset(logical_path)
          write_asset(asset)
        end
      end
    end

    private

    def write_asset(asset)
      asset.logical_path.tap do |path|
        filename = File.join folder, path
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
      raise 'Must be implemented by a subclass'
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
