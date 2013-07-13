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

desc "remove all gems"
task :rm_gems do
  sh "rm *.gem" rescue nil
end

desc "build the gem"
task :gem => :rm_gems do
  sh "gem build funkify.gemspec"
end

desc "display the current version"
task :version do
  puts Funkify::VERSION
end

desc "build and push latest gems"
task :pushgem => :gem do
  Dir["*.gem"].each do |gemfile|
    sh "gem push funkify-#{Funkify::VERSION}.gem"
  end
end
