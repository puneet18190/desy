require 'zip/zip'

require 'export'

require 'env_relative_path'

module Export
  module Lesson
    ASSETS_FOLDER = Rails.root.join 'app', 'exports', 'lessons', 'assets'
  end
end
