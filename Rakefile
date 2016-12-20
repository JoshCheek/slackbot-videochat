task default: :test

desc 'Deploy code to prod'
task deploy: :test do
  sh *%w'git push heroku master:master'
end

desc 'Test the Ruby code'
task :test do
  sh *%w'rspec --fail-fast --colour --format documentation'
end
