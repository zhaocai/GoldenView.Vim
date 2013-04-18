require 'facets/string'
require 'rake/clean'

project_name = __FILE__.pathmap("%-1d")

def version
  project_readme = FileList['README.*']
  version_re = /Version \s+ : \s* (?<version> \d\.\d\.\d) $/x

  project_readme.each { |f| 
    File.read(f).mscan(version_re).each { |m| 
      return m[:version]
    }
  }
end

desc "version"
task :version => [] do
  puts version
end




desc "zip for distribution"
task :zip => [] do
  sh "zip -r #{project_name}-#{version}.zip",
     "autoload plugin doc README.md", "--exclude \*.DS_Store "
end

CLEAN.include('*.zip')




vimup = File.expand_path('~/Developer/Vim/Bundle/tool/vimup/vimup')
vimorg = File.expand_path('~/.apps/vimup/vim.org.yml')

namespace :vimup do
  desc "new vim.org script"
  task :new do
    sh vimup, 'new-script', project_name, vimorg
  end

  desc "updae vim.org script"
  task :release => [:zip] do
    sh vimup, 'update-script', project_name, vimorg
  end

  desc "updae vim.org script detail"
  task :details do
    sh vimup, 'update-details', project_name, vimorg
  end
end
