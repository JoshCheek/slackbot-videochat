directory 'app/public'

desc 'Build for deploy since Heroku makes it difficult to build there'
task deploy: :test do
  sh 'git', 'push', '--force', 'heroku', 'master:master'
end


desc 'Run all tests'
task test: %w[test:ruby test:js]
namespace :test do
  desc 'Rest the ruby code'
  task 'ruby' do
    sh 'rspec', '--colour'
  end
  task 'js' do
    # TODO: javascript
  end
end

