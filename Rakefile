require 'rake'

<<<<<<< HEAD
#task :default => [:install]

$LOAD_PATH.unshift('lib')

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "Athenry"
    gem.summary = "Opinionated tool to build Gentoo stages."
    gem.email = "netzdamon@gmail.com"
    gem.homepage = "http://github.com/gregf/athenry"
    gem.description = "Opinionated tool to build Gentoo stages."
    gem.authors = ["Greg Fitzgerald"]
    gem.version = "0.0.1"
   
    gem.add_dependency "commander", ">= 3.2"
    gem.add_dependency "configatron", ">= 2.5"
   
    gem.add_development_dependency "yard"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
 
Jeweler::RubyforgeTasks.new do |t|
  t.doc_task = :yardoc
end

=======
# =======================
# = Documentation tasks =
# =======================
>>>>>>> b096f27... Use jeweler to make a gem
begin
  require 'yard'
  require 'yard/rake/yardoc_task'
  
  task :documentation => :'documentation:generate'
  namespace :documentation do
    YARD::Rake::YardocTask.new :generate do |t|
      t.files   = ['lib/**/*.rb']
      t.options = ['--output-dir', File.join('meta', 'documentation'),
                   '--title', 'Athenry YARD documentation',
                   '--readme', 'README.markdown',
                   '--files', 'doc/about.markdown',
                   '--files', 'doc/quickstart.markdown',
                   '--files', 'AUTHORS.markdown', 
                   '--files', 'TODO.markdown',
                   '--files', 'MIT-LICENSE']
    end
    
    YARD::Rake::YardocTask.new :dotyardoc do |t|
      t.files   = ['lib/**/*.rb']
      t.options = ['--no-output',
                   '--title', 'Athenry YARD documentation',
                   '--readme', 'README.markdown',
                   '--files', 'doc/about.markdown',
                   '--files', 'doc/quickstart.markdown',
                   '--files', 'AUTHORS.markdown', 
                   '--files', 'TODO.markdown', 
                   '--files', 'MIT-LICENSE']
    end
  end
  
rescue LoadError
  desc 'You need the `yard` gem to generate documentation'
  task :documentation
end

