require "bundler/gem_tasks"

desc "Set up and run tests"
task :default => [:test]

def run_specs paths
  quiet = ENV['VERBOSE'] ? '' : '-q'
  exec "bacon -Ispec -rubygems #{quiet} #{paths.join ' '}"
end

desc "run tests"
task :test do
  run_specs Dir['spec/**/*_spec.rb'].shuffle!
end

desc "run pry with the development version of funkify loaded"
task :pry do
  sh "pry -I./lib -r funkify"
end
