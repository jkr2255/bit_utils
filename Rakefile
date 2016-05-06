require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rake/extensiontask"

task :build => :compile

Rake::ExtensionTask.new("bit_utils") do |ext|
  ext.lib_dir = "lib/bit_utils"
end

task :default => [:clobber, :compile, :spec]
