require 'rake'

#task :default => [:install]

$LOAD_PATH.unshift('lib')
 
require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "Athenry"
  gem.summary = "Opinionated tool to build Gentoo stages."
  gem.email = "netzdamon@gmail.com"
  gem.homepage = "http://github.com/gregf/athenry"
  gem.description = "Opinionated tool to build Gentoo stages."
  gem.authors = ["Greg Fitzgerald"]
  gem.version = "0.0.1"
 
  gem.add_dependency "visionmedia-commander", ">= 3.2"
  gem.add_dependency "configatron", ">= 2.5"
 
  gem.add_development_dependency "yard"
end
 
Jeweler::GemcutterTasks.new

Jeweler::RubyforgeTasks.new do |t|
  t.doc_task = :yardoc
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new(:yardoc) do |t|
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
rescue LoadError
  task :yardoc => :check_dependencies
end
