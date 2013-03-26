namespace :doc do
  desc "Generates the javascript documentation"
  task :js do
    js_src_dir = 'app/assets/javascripts/'
    js_doc_dir = 'doc/js'

    command = "yuidoc -o #{js_doc_dir.shellescape} #{js_src_dir.shellescape}"

    puts "Running `#{command}` ..."
    `#{command}`
  end
end