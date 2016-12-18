directory 'app/public'

def client_files
  Dir['client/build/static/{css,js}/*.{css,js}']
end

desc 'Build the javascript and put the files where they go'
task build: 'app/public' do
  # we could use file dependencies to determine if we actually need to build it,
  # but it's not worth the complexity for just two files and no situations that would obviously benefit from it
  cd 'client'
  sh 'npm', 'run', 'build'
  cd '..'

  client_files.each do |from_path|
    bare_name = File.basename(from_path).gsub(/\.[0-9a-f]+\./, '.')
    to_path   = File.join 'app', 'public', bare_name
    cp from_path, to_path
  end
end


desc 'Run all tests'
task test: %w[test:ruby test:js]
namespace :test do
  desc 'Rest the ruby code'
  task 'ruby' do
    # TODO: rspec
  end
  task 'js' do
    # TODO: javascript
  end
end
