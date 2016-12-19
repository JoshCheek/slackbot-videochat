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


desc 'Build for deploy since Heroku makes it difficult to build there'
task deploy: [:test, :build] do
  sh <<-BASH
    # stop on error
    set -eu
    set -o pipefail

    if ! git diff-index --quiet HEAD -- ; then
      echo "Commit your changes first" >&2
      exit 1
    fi

    # we'll do our work here
    git checkout -b deploy

    # force add since generated files are ignored
    git add -f app/public
    git commit -m 'Build assets for deploy'

    # force push so our history isn't full of old irrelevant builds
    git push --force heroku deploy:master

    # back to the prev branch and kill deploy branch
    git checkout -
    git branch -D deploy
  BASH
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

