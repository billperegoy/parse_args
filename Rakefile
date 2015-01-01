require 'rspec/core/rake_task'
require 'cane/rake_task'

RSpec::Core::RakeTask.new(:spec)
Cane::RakeTask.new(:cane) do |cane|
  cane.no_doc = true
  cane.abc_max = 10
end

task :build_gem do
  `gem build parse_args.gemspec`
end

task :default => [:spec, :cane]
