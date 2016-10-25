#encoding: utf-8
require_relative 'spec_helper'

describe StanfordCoreNLP do
  before(:each) do
    StanfordCoreNLP.jvm_args = ['-Xms2G', '-Xmx2G']
    StanfordCoreNLP.use :french
    StanfordCoreNLP.model_files = {}
    StanfordCoreNLP.set_model('pos.model', 'french.tagger')
    StanfordCoreNLP.default_jars = [
      'joda-time.jar',
      'xom.jar',
      'stanford-corenlp-3.5.0.jar',
      'stanford-corenlp-3.5.0-models.jar',
      'jollyday.jar',
      'bridge.jar'
    ]
  end

  context "when the whole pipeline is run on a French text" do
    it "should get correct the sentences, tokens, POS tags, lemmas and syntactic tree" do
      pipeline = StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse)
      text = "Bonjour, je suis bel et bien arrivé au château. Le roi m'a donné un biscuit."
      text = StanfordCoreNLP::Annotation.new(text)
      pipeline.annotate(text)

      sentences, tokens, tags, lemmas, begin_char, last_char = *get_information(text)

      expect(sentences).to eq ["Bonjour, je suis bel et bien arrivé au château.", "Le roi m'a donné un biscuit."]
      expect(tokens).to eq %w[Bonjour , je suis bel et bien arrivé au château . Le roi m ' a donné un biscuit .]
      #Old expectation that passes with the package avaible at http://louismullie.com/treat/stanford-core-nlp-full.zip
      # tags.should eql %w[I , CL V ADV C ADV V P N . D N N N V V D N .]
      expect(tags).to eq %w[I PUNC CLS V ADV C ADV VPP P NC PUNC DET NC NC ADJ V VPP DET NC PUNC]
      expect(lemmas).to eq %w[bonjour , je sui bel et bien arrivé au château . le rous m ' a donné un biscuit .]
      expect(begin_char).to eq [0, 7, 9, 12, 17, 21, 24, 29, 36, 39, 46, 48, 51, 55, 56, 57, 59, 65, 68, 75]
      expect(last_char).to eq [7, 8, 11, 16, 20, 23, 28, 35, 38, 46, 47, 50, 54, 56, 57, 58, 64, 67, 75, 76]
    end
  end
end
