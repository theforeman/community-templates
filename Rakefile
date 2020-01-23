require 'rake/testtask'
$LOAD_PATH << "test"
require "test_helper"

task :default => :test

desc 'Validate Red Hat kickstarts using ksvalidate and Debian preseeds using debconf-set-selections'
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*test.rb']
  t.verbose = true
end
