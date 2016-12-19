task default: :test

desc 'Build for deploy since Heroku makes it difficult to build there'
task deploy: :test do
  sh 'git', 'push', '--force', 'heroku', 'master:master'
end

desc 'Test the Ruby code'
task :test do
  sh 'rspec', '--fail-fast', '--colour', '--format', 'documentation'
end

