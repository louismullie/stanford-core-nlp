#encoding: utf-8
require 'test/unit'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'stanford-core-nlp'

#StanfordCoreNLP.model_path = '/ruby/stanford/models/'
#StanfordCoreNLP.jar_path = '/ruby/stanford/bin/'

module StanfordCoreNLP
  
  class TestStanfordCoreNLP < Test::Unit::TestCase

    def test_load_class
      
      StanfordCoreNLP.load_class('PTBTokenizerAnnotator')
      assert_equal true,
      StanfordCoreNLP::PTBTokenizerAnnotator.
      respond_to?(:java_methods)
      
    end
    
    def test_all_french
      
      # Can't test both french and english at same time.
      return 0
      
      # Reset default values to make sure
      # that these features work.
      StanfordCoreNLP.use(:french)
      pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse)
      text = "Bonjour, je suis bel et bien arrivé au château. Le roi m'a donné un biscuit."
      text = StanfordCoreNLP::Text.new(text)
      pipeline.annotate(text)
      
      sentences, tokens, tags, lemmas, begin_char, last_char = *get_information(text)
      
      assert_equal ["Bonjour, je suis bel et bien arrivé au château.", 
                    "Le roi m'a donné un biscuit."], sentences
      assert_equal %w[Bonjour , je suis bel et bien arrivé au château . Le roi m ' a donné un biscuit .], tokens
      assert_equal %w[I , CL V ADV C ADV V P N . D N N N V V D N .], tags
      assert_equal %w[bonjour , je sui bel et bien arrivé au château . le roi m ' a donné un biscuit .], lemmas
      assert_equal [0, 7, 9, 12, 17, 21, 24, 29, 36, 39, 46, 48, 51, 55, 56, 57, 59, 65, 68, 75], begin_char
      assert_equal [7, 8, 11, 16, 20, 23, 28, 35, 38, 46, 47, 50, 54, 56, 57, 58, 64, 67, 75, 76], last_char
      
    end

    def test_all_english
      
      # Reset default values to make sure
      # that these features work.
      StanfordCoreNLP.use(:english)
      StanfordCoreNLP.set_model('pos.model', 'english-left3words-distsim.tagger')
      StanfordCoreNLP.set_model('parser.model', 'englishPCFG.ser.gz')

      text = 'Angela Merkel met Nicolas Sarkozy on January 25th in ' +
      'Berlin to discuss a new austerity package.'

      pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse)
      text = StanfordCoreNLP::Text.new(text)
      pipeline.annotate(text)

      sentences, tokens, tags, lemmas, begin_char, last_char = *get_information(text)
      
      assert_equal ['Angela Merkel met Nicolas Sarkozy on January 25th ' +
      'in Berlin to discuss a new austerity package.'], sentences
      assert_equal %w[Angela Merkel met Nicolas Sarkozy on
      January 25th in Berlin to discuss a new austerity package .], tokens
      assert_equal %w[Angela Merkel meet Nicolas Sarkozy on
      January 25th in Berlin to discuss a new austerity package .], lemmas
      assert_equal %w[NNP NNP VBD NNP NNP IN NNP JJ IN NNP TO VB DT JJ NN NN .], tags
      assert_equal [0, 7, 14, 18, 26, 34, 37, 45, 50, 53, 60, 63, 71, 73, 77, 87, 94], begin_char
      assert_equal [6, 13, 17, 25, 33, 36, 44, 49, 52, 59, 62, 70, 72, 76, 86, 94, 95], last_char
      
    end
    
    def get_information(text)
      
      sentences = []
      
      tokens = []
      tags = []
      lemmas = []
      begin_char = []
      last_char = []

      text.get(:sentences).each do |sentence|

        sentences << sentence.to_s
        sentence.get(:tokens).each do |token|
          tokens << token.get(:value).to_s
          begin_char << token.get(:character_offset_begin).to_s.to_i
          last_char << token.get(:character_offset_end).to_s.to_i
          tags << token.get(:part_of_speech).to_s
          lemmas << token.get(:lemma).to_s
          # name_tags << token.get(:named_entity_tag).to_s
          # coref_ids << token.get(:coref_cluster_id).to_s
        end

      end
      
      [sentences, tokens, tags, lemmas, begin_char, last_char]
  
    end
    
  end
end