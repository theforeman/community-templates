require 'rake/testtask'

task :default => :test

desc 'Validate Red Hat kickstarts using ksvalidate'
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*test.rb']
  t.verbose = true
end
