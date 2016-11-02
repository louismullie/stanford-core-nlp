#encoding: utf-8
require_relative 'spec_helper'

describe StanfordCoreNLP do
  before(:each) do
    StanfordCoreNLP.jvm_args = ['-Xms2G', '-Xmx2G']
    # @todo Hack! Change this!
    StanfordCoreNLP.jar_path = File.dirname(__FILE__) + '/bin/'
    StanfordCoreNLP.use :german
    StanfordCoreNLP.model_files = {}
    StanfordCoreNLP.set_model('pos.model', 'german-fast.tagger')
    StanfordCoreNLP.default_jars = [
      'joda-time.jar',
      'xom.jar',
      'stanford-corenlp-3.5.0.jar',
      'stanford-corenlp-3.5.0-models.jar',
      'jollyday.jar',
      'bridge.jar'
    ]
  end

  context 'when the whole pipeline is run on a German text' do
    it 'should get the correct sentences, tokens, POS tags, lemmas and syntactic tree' do
      pipeline = StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse)
      text = 'Du hast deiner Frau einen roten Ring gekauft.'
      text = StanfordCoreNLP::Annotation.new(text)
      pipeline.annotate(text)

      sentences, tokens, tags, lemmas, begin_char, last_char = *get_information(text)
      expect(sentences).to eq ['Du hast deiner Frau einen roten Ring gekauft.']
      expect(tokens).to eq %w(Du hast deiner Frau einen roten Ring gekauft .)
      expect(tags).to eq ["PPER", "VAFIN", "PPOSAT", "NN", "ART", "ADJA", "NN", "VVPP", "$."]
      expect(lemmas).to eq ["du", "hast", "deiner", "frau", "einen", "roten", "ring", "gekauft", "."]
      expect(begin_char).to eq [0, 3, 8, 15, 20, 26, 32, 37, 44]
      expect(last_char).to eq [2, 7, 14, 19, 25, 31, 36, 44, 45]
    end
  end
end
