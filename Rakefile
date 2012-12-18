require 'rspec/core/rake_task'

# Note that we need to run each language
# spec in a separate rake task. This is 
# because the language for the Stanford 
# Core NLP pipeline can only be set once.
task :spec, [:language] do |t, args|
  
  languages = ['english', 'german', 'french']
  language = args.language
  
  if language
    unless languages.include?(language)
      raise 'Invalid language.'
    end
    f = ["spec/#{language}_spec.rb"]
    RSpec::Core::Runner.run(f)
  else
    code = 0
    languages.each do |language|
      s = `rspec spec/#{language}_spec.rb`
      code = 1 unless s.index('0 failures')
    end
    exit code
  end
  
end

task :default => :spec