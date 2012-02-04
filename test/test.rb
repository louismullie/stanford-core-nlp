require 'test/unit'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'stanford-core-nlp'

module StanfordCoreNLP
  class TestStanfordCoreNLP < Test::Unit::TestCase
    
    def test_load_class
      StanfordCoreNLP.load_class('PTBTokenizerAnnotator')
      assert_equal true, StanfordCoreNLP::PTBTokenizerAnnotator.respond_to?(:java_methods)
    end
    
    def test_all_english
      # Reset default values to make sure that these features work.
      StanfordCoreNLP.use(:english)
      StanfordCoreNLP.set_model('pos.model', 'english-left3words-distsim.tagger')
      
      text = 'Angela Merkel met Nicolas Sarkozy on January 25th in ' +
      'Berlin to discuss a new austerity package. Sarkozy ' +
      'looked pleased, but Merkel was dismayed.'
      
      pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref)
      text = StanfordCoreNLP::Text.new(text)
      pipeline.annotate(text)
      
      text.get(:sentences).each do |sentence|
        
        puts "Sentence: '#{sentence.to_s}.'"
        puts 'Number of children of the sentence node (first-level): ' + 
             sentence.get(:tree).num_children.to_s
        
        sentence.get(:tokens).each do |token|
          # Default annotations for all tokens
          puts 'Token: ' +                          token.get(:value).to_s
          puts 'Original text: ' +                  token.get(:original_text).to_s
          puts 'First character\'s position: ' +    token.get(:character_offset_begin).to_s
          puts 'Second character\'s position: ' +   token.get(:character_offset_end).to_s
          # POS returned by the tagger
          puts 'POS: ' +                            token.get(:part_of_speech).to_s
          # Lemma (base form of the token)
          puts 'Lemma: ' +                          token.get(:lemma).to_s
          # Named entity tag
          puts 'Named entity tag: ' +               token.get(:named_entity_tag).to_s
          # Coreference
          puts 'Coreference cluster id: ' +         token.get(:coref_cluster_id).to_s
          # Also available: coref_chain, coref_cluster, coref_dest, coref_graph.
          puts
        end
        
      end
    end
  end
end
