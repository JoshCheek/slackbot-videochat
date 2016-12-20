def self.port
  ENV.fetch 'PORT', 9292
end

def self.sh(*args)
  super *args.flatten.map(&:to_s)
end

task default: :test

desc 'Deploy code to Heroku'
task deploy: :test do
  sh %W[git push heroku master:master]
end

desc 'Test the Ruby code'
task :test do
  sh %W[bundle exec rspec --fail-fast --colour --format documentation]
end

desc 'Run the dev server'
task :serve do
  sh %W[bundle exec rackup config.ru -p], port
end

desc 'Expose the dev server by tunneling localhost to ngrok (you\'ll need to configure ngrok)'
task :ngrok do
  sh %W'ngrok http', port
end
