require 'env_relative_path'
require 'find'
require 'media'

class DocumentUploader < CarrierWave::Uploader::Base

  include EnvRelativePath

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  storage :file

  STORE_DIR = env_relative_path "documents"
  FOLDER    = Media::RAILS_PUBLIC_FOLDER.join(STORE_DIR).to_s

  attr_reader :original_filename

  def self.remove_folder!
    FileUtils.rm_rf FOLDER
  end

  def self.folder_size
    return 0 unless Dir.exists? FOLDER
    Find.find(FOLDER).sum { |f| File.stat(f).size }
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    File.join STORE_DIR, "#{model.id}"
  end

  def cache_dir
    Rails.root.join 'tmp/documents'
  end

  def folder
    File.dirname path if path
  end

  def original_extension
    File.extname(original_filename) if original_filename
  end

  def original_filename_without_extension
    File.basename(original_filename, original_extension) if original_filename
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{original_filename_without_extension.parameterize}_#{model.filename_token}#{original_extension}" if original_filename
  end

end
