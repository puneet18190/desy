namespace :doc do

  desc "Generates the javascript documentation"
  task :js do
    js_src_dir = File.expand_path '../../app/assets/javascripts/',  __dir__
    js_doc_dir = File.expand_path '../../doc/js', __dir__

    command = "yuidoc -o #{js_doc_dir.shellescape} #{js_src_dir.shellescape}"

    puts "Running `#{command}` ..."
    `#{command}`
  end
end