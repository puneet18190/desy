namespace :doc do
  desc "Generates the javascript documentation"
  task :js do
    js_src_dir = 'app/assets/javascripts/'
    js_doc_dir = 'doc/js'

    command = "cd #{Rails.root.to_s.shellescape} && yuidoc -c config/yuidoc.json -o #{js_doc_dir.shellescape} #{js_src_dir.shellescape}"

    puts "Running `#{command}` ..."
    `#{command}`
  end
end