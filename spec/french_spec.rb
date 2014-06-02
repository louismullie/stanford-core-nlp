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
      'stanford-corenlp-3.3.1.jar',
      'stanford-corenlp-3.3.1-models.jar',
      'jollyday.jar',
      'bridge.jar'
    ]
  end

  context "when the whole pipeline is run on a French text" do
    it "should get correct the sentences, tokens, POS tags, lemmas and syntactic tree" do
      pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse)
      text = "Bonjour, je suis bel et bien arrivé au château. Le roi m'a donné un biscuit."
      text = StanfordCoreNLP::Annotation.new(text)
      pipeline.annotate(text)

      sentences, tokens, tags, lemmas, begin_char, last_char = *get_information(text)

      sentences.should eql ["Bonjour, je suis bel et bien arrivé au château.", "Le roi m'a donné un biscuit."]
      tokens.should eql %w[Bonjour , je suis bel et bien arrivé au château . Le roi m ' a donné un biscuit .]
      #Old expectation that passes with the package avaible at http://louismullie.com/treat/stanford-core-nlp-full.zip
      # tags.should eql %w[I , CL V ADV C ADV V P N . D N N N V V D N .]
      tags.should eql %w[I PUNC CL V ADV C ADV V P N PUNC D N N CL V V D N PUNC]
      lemmas.should eql %w[bonjour , je sui bel et bien arrivé au château . le roi m ' a donné un biscuit .]
      begin_char.should eql [0, 7, 9, 12, 17, 21, 24, 29, 36, 39, 46, 48, 51, 55, 56, 57, 59, 65, 68, 75]
      last_char.should eql [7, 8, 11, 16, 20, 23, 28, 35, 38, 46, 47, 50, 54, 56, 57, 58, 64, 67, 75, 76]
    end
  end
end