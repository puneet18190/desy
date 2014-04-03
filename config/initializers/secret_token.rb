# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

# Reading the secret key from a non-versioned file

# TODO Rimuovere il check del vecchio file quando si sarà sicuri che non ce ne staranno più

old_secret_key_base_path = Rails.root.join('config/secret_token')
secret_key_base_path = Rails.root.join('config/secret_key_base')

if File.exist?(old_secret_key_base_path) && !File.exist?(secret_key_base_path)
  require 'fileutils'
  FileUtils.mv old_secret_key_base_path, secret_key_base_path
end

secret_key_base = (secret_key_base_path.exist? and secret_key_base_path.read.chomp) or (
  warn "The file #{secret_key_base_path} does not exists or is empty."
  warn "Generating a new secret token and writing to #{secret_key_base_path}; this will invalidate the previous Rails sessions."

  require 'securerandom'
  SecureRandom.hex(64).tap do |token|
    secret_key_base_path.open('w') { |io| io.write token }
  end
)
Desy::Application.config.secret_key_base = secret_key_base
