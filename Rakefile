require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "blogitr"
    gem.summary = %Q{TODO}
    gem.email = "git@randomhacks.net"
    gem.homepage = "http://github.com/emk/blogitr"
    gem.authors = ["Eric Kidd"]

    gem.add_runtime_dependency 'RedCloth', [">= 4.1.9"]
    gem.add_runtime_dependency 'rdiscount', [">= 1.3.4"]

    gem.add_development_dependency 'rspec', [">= 1.1.11.3"]

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

Spec::Rake::SpecTask.new('SPECS') do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = %w(--format progress --format specdoc:SPECS)
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "blogitr #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('SPECS')
  rdoc.rdoc_files.include('LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
