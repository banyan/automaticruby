# encoding: utf-8

require 'rubygems'

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ["-c"]
  spec.pattern = FileList['spec/**/*_spec.rb']
end

if /^1\.9\./ =~ RUBY_VERSION
  desc "Run RSpec code examples with simplecov"
  task :simplecov do
    ENV['COVERAGE'] = "on"
    Rake::Task[:spec].invoke
  end
else
  desc "Run RSpec code examples with rcov"
  RSpec::Core::RakeTask.new(:rcov) do |spec|
    spec.pattern = FileList['spec/**/*_spec.rb']
    exclude_files = [
      "gems",
    ]
    spec.rcov_opts = ['--exclude', exclude_files.join(",")]
    spec.rcov = true
  end
end
