require 'rspec'

require_relative '../lib/stanford-core-nlp'

# StanfordCoreNLP.model_path = '/ruby/stanford-core-nlp-minimal/both/' # Local testing only
# StanfordCoreNLP.jar_path = '/ruby/stanford-core-nlp-minimal/both/'   # Local testing only.

def get_information(text, with_name_tag=false, with_coref=false)

  sentences, tokens, tags, = [], [], []
  lemmas, begin_char, last_char = [], [], []
  name_tags, coref_ids = [], []
  
  text.get(:sentences).each do |sentence|
    sentences << sentence.to_s
    sentence.get(:tokens).each do |token|
      tokens << token.get(:value).to_s
      begin_char << token.get(:character_offset_begin).to_s.to_i
      last_char << token.get(:character_offset_end).to_s.to_i
      tags << token.get(:part_of_speech).to_s
      lemmas << token.get(:lemma).to_s
      name_tags << token.get(:named_entity_tag).to_s if with_name_tag
      coref_ids << token.get(:coref_cluster_id).to_s if with_coref
    end

  end

  [sentences, tokens, tags, lemmas, begin_char, last_char, name_tags, coref_ids]

end