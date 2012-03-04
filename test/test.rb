require 'test/unit'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'stanford-core-nlp'

module StanfordCoreNLP
  class TestStanfordCoreNLP < Test::Unit::TestCase

    def test_load_class
      StanfordCoreNLP.load_class('PTBTokenizerAnnotator')
      assert_equal true,
      StanfordCoreNLP::PTBTokenizerAnnotator.
      respond_to?(:java_methods)
    end

    def test_all_english

      #StanfordCoreNLP.model_path = '/ruby/gems/treat/models/stanford/'
      #StanfordCoreNLP.jar_path = '/ruby/gems/treat/bin/stanford/'

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
  end
end
