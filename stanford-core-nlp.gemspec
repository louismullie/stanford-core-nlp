# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'stanford-core-nlp/version'

Gem::Specification.new do |s|
  s.name        = 'stanford-core-nlp'
  s.version     = StanfordCoreNLP::VERSION
  s.authors     = ['Louis Mullie', 'Andrei Beliankou']
  s.email       = ['arbox@yandex.ru']
  s.homepage    = 'https://github.com/louismullie/stanford-core-nlp'
  s.summary     = 'Ruby bindings to the Stanford Core NLP tools.'
  s.description = 'High-level Ruby bindings to the Stanford CoreNLP package, '\
                  'a set natural language processing tools that provides '\
                  'tokenization, part-of-speech tagging and parsing for several '\
                  'languages, as well as named entity recognition and coreference '\
                  'resolution for English, German, French and other languages.'

  # Add all files.
  s.files = Dir['lib/**/*'] + Dir['bin/**/*.java'] + ['README.md', 'LICENSE']

  # Runtime dependencies
  s.add_runtime_dependency 'bind-it', '~> 0.2.7'

  # license
  s.license = 'GPL-3.0'

  # Post-install message.
  s.post_install_message = 'This is an alpha release. Stay tuned!'
end
