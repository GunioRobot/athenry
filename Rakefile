require 'rake'

@gems=%w[commander configatron]

# =======================
# = Install gems =
# =======================

desc "install gems"
task 'install:gems' do
  @gems.each {|gem| system("sudo gem install #{gem}") }
end

# =======================
# = Installation tasks =
# =======================

desc "install athenry"
task :install do
  system("setup.rb install")
end
desc "uninstall athenry"
task :uninstall do
  system("setup.rb uninstall")
end

# =======================
# = Build Tar =
# =======================

namespace :build do
  desc "Generate tarball"
    task :tar do
      system("tar -cjf athenry-latest.tar.bz2 ../athenry --exclude 'athenry-latest.tar.bz2' --exclude '.git' --exclude='.yardoc' --exclude '.gitignore' --exclude '.gitmodules'")
  end
end

# =======================
# = Documentation tasks =
# =======================
begin
  require 'yard'
  require 'yard/rake/yardoc_task'

  namespace :documentation do
    YARD::Rake::YardocTask.new :generate do |t|
      t.files   = ['lib/**/*.rb']
      t.options = ['--output-dir', File.join('meta', 'documentation'),
                   '--title', 'Athenry YARD documentation',
                   '--readme', 'README.md',
                   '--files', 'doc/About.md',
                   '--files', 'doc/QuickStart.md',
                   '--files', 'doc/Release.md',
                   '--files', 'doc/Hacking.md',
                   '--files', 'doc/History.md',
                   '--files', 'AUTHORS.md', 
                   '--files', 'TODO.md',
                   '--files', 'MIT-LICENSE']
    end
   
    YARD::Rake::YardocTask.new :dotyardoc do |t|
      t.files   = ['lib/**/*.rb']
      t.options = ['--no-output',
                   '--title', 'Athenry YARD documentation',
                   '--readme', 'README.md',
                   '--files', 'doc/About.md',
                   '--files', 'doc/QuickStart.md',
                   '--files', 'doc/Release.md',
                   '--files', 'doc/Hacking.md',
                   '--files', 'doc/History.md',
                   '--files', 'AUTHORS.md', 
                   '--files', 'TODO.md', 
                   '--files', 'MIT-LICENSE']
    end
    desc "Generate Yard Diagram"
    task :diagram do
      system("yard-graph --dependencies --full | dot -T png -o diagram.png")
    end
  end
  
rescue LoadError
  desc 'You need the `yard` gem to generate documentation'
  task :documentation
end

