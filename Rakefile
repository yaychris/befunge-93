require "rake"
require "rake/testtask"

task :default => [:test]


Rake::TestTask.new :test do |t|
  t.libs = ["lib", "test"]
  t.test_files = FileList['test/ts*.rb']
  t.verbose = true
end


desc "Code coverage with rcov"
task :rcov do
  `rcov -Ilib:test test/ts_befunge.rb`
  `open coverage/index.html`
end