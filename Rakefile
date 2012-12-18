require 'rspec/core/rake_task'

# Note that we need to run each language
# spec in a separate rake task. This is 
# because the language for the Stanford 
# Core NLP pipeline can only be set once.
task :spec, [:language] do |t, args|
  require_relative 'spec/spec_helper.rb'
  if args.language
    f = ["spec/#{args.language}_spec.rb"]
    RSpec::Core::Runner.run(f)
  else
    ls = [:english, :german, :arabic,
          :french,  :chinese]
    error = false
    ls.each do |language|
      s = `rake spec[#{language}]`
      unless s.index('0 failures')
        error = true
      end
    end
    exit error ? 1 : 0
  end
end

task :default => :spec