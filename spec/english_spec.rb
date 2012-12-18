#encoding: utf-8

describe StanfordCoreNLP do
  
  context "when the whole pipeline is run on an English text" do
    it "should get the sentences, tokens, POS tags, lemmas and syntactic tree" do
      StanfordCoreNLP.use(:english)
      StanfordCoreNLP.set_model('pos.model', 'english-left3words-distsim.tagger')
      StanfordCoreNLP.set_model('parse.model', 'englishPCFG.ser.gz')
      text = 'Angela Merkel met Nicolas Sarkozy on January 25th in Berlin to discuss a new austerity package.'
      pipeline = StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse)
      text = StanfordCoreNLP::Annotation.new(text)
      pipeline.annotate(text)
      
      sentences, tokens, tags, lemmas, begin_char, last_char = *get_information(text)
      sentences.should eql ['Angela Merkel met Nicolas Sarkozy on January 25th in Berlin to discuss a new austerity package.']
      tokens.should eql %w[Angela Merkel met Nicolas Sarkozy on January 25th in Berlin to discuss a new austerity package .]
      lemmas.should eql %w[Angela Merkel meet Nicolas Sarkozy on January 25th in Berlin to discuss a new austerity package .]
      tags.should eql %w[NNP NNP VBD NNP NNP IN NNP JJ IN NNP TO VB DT JJ NN NN .]
      begin_char.should eql [0, 7, 14, 18, 26, 34, 37, 45, 50, 53, 60, 63, 71, 73, 77, 87, 94]
      last_char.should eql [6, 13, 17, 25, 33, 36, 44, 49, 52, 59, 62, 70, 72, 76, 86, 94, 95]
    end
  end

end