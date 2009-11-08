require 'rake'

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
                   '--readme', 'README.markdown',
                   '--files', 'doc/about.markdown',
                   '--files', 'doc/quickstart.markdown',
                   '--files', 'doc/release.markdown',
                   '--files', 'doc/hacking.markdown',
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
                   '--files', 'doc/release.markdown',
                   '--files', 'doc/hacking.markdown',
                   '--files', 'AUTHORS.markdown', 
                   '--files', 'TODO.markdown', 
                   '--files', 'MIT-LICENSE']
    end
  end
  
rescue LoadError
  desc 'You need the `yard` gem to generate documentation'
  task :documentation
end

