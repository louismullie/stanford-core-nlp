#encoding: utf-8
require_relative 'spec_helper'

describe StanfordCoreNLP do
  
  context "when the whole pipeline is run on a German text" do
    
    it "should get the correct sentences, tokens, POS tags, lemmas and syntactic tree" do
      
      StanfordCoreNLP.use(:german)
      pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse)
      text = "Du hast deiner Frau einen roten Ring gekauft."
      text = StanfordCoreNLP::Annotation.new(text)
      pipeline.annotate(text)
      
      sentences, tokens, tags, lemmas, begin_char, last_char = *get_information(text)
      sentences.should eql ["Du hast deiner Frau einen roten Ring gekauft."]
      tokens.should eql ["Du", "hast", "deiner", "Frau", "einen", "roten", "Ring", "gekauft", "."]
      tags.should eql ["PPER", "VAFIN", "ADJA", "NN", "ART", "ADJA", "NN", "VVPP", "$."]
      lemmas.should eql ["du", "hast", "deiner", "frau", "einen", "roten", "ring", "gekauft", "."]
      begin_char.should eql [0, 3, 8, 15, 20, 26, 32, 37, 44]
      last_char.should eql [2, 7, 14, 19, 25, 31, 36, 44, 45]
      
    end
    
  end

end