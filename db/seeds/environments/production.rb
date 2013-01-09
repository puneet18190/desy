seeds_folder = File.join File.expand_path('..', __FILE__), Rails.env
sql_seeds = File.join seeds_folder, 'seeds.sql'

puts 'Executing the SQL seeding...'
ActiveRecord::Base.connection.execute(File.read(sql_seeds))

begin
  FileUtils.rm_rf Rails.root.join('public/media_elements')
rescue Errno::ENOENT
end

puts 'Copying media elements...'
FileUtils.cp_r File.join(seeds_folder, 'media_elements'), Rails.root.join('public')
