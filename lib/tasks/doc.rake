# clear the doc:app task et al so we can rewrite them
Rake::Task["doc:app"].clear
Rake::Task["doc/app"].clear
Rake::Task["doc/app/index.html"].clear


namespace :doc do

  desc "Generate documentation for the application"
  Rake::RDocTask.new('app') do |rdoc|

    require 'sdoc'

    rdoc.rdoc_dir = 'doc/app'
    rdoc.title    = "DESY - Digital Educational SYstem application documentation"
    rdoc.main     = 'doc/README.rdoc'

    rdoc.options << '--fmt' << 'sdoc'
    rdoc.options << '--charset' << 'utf-8'

    rdoc.rdoc_files.include('app/**/*.rb')
    rdoc.rdoc_files.include('lib/**/*.rb')
    rdoc.rdoc_files.include('doc/README.rdoc')
  end

  desc "Build JS documentation"
  task :js do
    js_src_dir = 'app/assets/javascripts/'
    js_doc_dir = 'doc/js'

    command = "cd #{Rails.root.to_s.shellescape} && yuidoc -c config/yuidoc.json -o #{js_doc_dir.shellescape} #{js_src_dir.shellescape}"

    puts "Running `#{command}` ..."
    `#{command}`
  end

end