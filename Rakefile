require 'rspec'

LANGUAGES = ['english', 'german', 'french']
# Note that we need to run each language
# spec in a separate rake task. This is
# because the language for the Stanford
# Core NLP pipeline can only be set once.
desc "Run specs for all defined languages: #{LANGUAGES.join(', ')}"
task :spec, [:language] do |_t, args|
  language_specs = []
  language = args.language

  if language
    unless LANGUAGES.include?(language)
      STDERR.puts "Invalid language #{language}."
      STDERR.puts "Defined languages: #{LANGUAGES.join(', ')}."
      exit 1
    end
    language_specs << "spec/#{language}_spec.rb"
  else
    LANGUAGES.each do |lang|
      language_specs << "spec/#{lang}_spec.rb"
    end
  end

  RSpec::Core::Runner.run(language_specs)
end

task :default => :spec
