#encoding: utf-8
require_relative 'spec_helper'

describe StanfordCoreNLP do
  before(:each) do
    StanfordCoreNLP.jvm_args = ['-Xms2G', '-Xmx2G']
    StanfordCoreNLP.use :english
    StanfordCoreNLP.model_files = {}
    StanfordCoreNLP.default_jars = [
      'joda-time.jar',
      'xom.jar',
      'stanford-corenlp-3.5.0.jar',
      'stanford-corenlp-3.5.0-models.jar',
      'jollyday.jar',
      'bridge.jar'
    ]
  end

  context "when the whole pipeline is run on an English text" do
    it "should get the correct sentences, tokens, POS tags, lemmas and syntactic tree" do
      text = 'Angela Merkel met Nicolas Sarkozy on January 25th in Berlin to discuss a new austerity package.'
      pipeline = StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref)
      text = StanfordCoreNLP::Annotation.new(text)
      pipeline.annotate(text)

      sentences, tokens, tags, lemmas, begin_char, last_char, name_tags, coref_ids = *get_information(text, true, true)

      expect(sentences).to eq ['Angela Merkel met Nicolas Sarkozy on January 25th in Berlin to discuss a new austerity package.']
      expect(tokens).to eq %w[Angela Merkel met Nicolas Sarkozy on January 25th in Berlin to discuss a new austerity package .]
      expect(lemmas).to eq %w[Angela Merkel meet Nicolas Sarkozy on January 25th in Berlin to discuss a new austerity package .]
      expect(tags).to eq %w[NNP NNP VBD NNP NNP IN NNP JJ IN NNP TO VB DT JJ NN NN .]
      expect(begin_char).to eq [0, 7, 14, 18, 26, 34, 37, 45, 50, 53, 60, 63, 71, 73, 77, 87, 94]
      expect(last_char).to eq [6, 13, 17, 25, 33, 36, 44, 49, 52, 59, 62, 70, 72, 76, 86, 94, 95]
      expect(name_tags).to eq %w[PERSON PERSON O PERSON PERSON O DATE DATE O LOCATION O O O O O O O]
      #Old expectation that passes with the package avaible at http://louismullie.com/treat/stanford-core-nlp-full.zip
      # coref_ids.should eql ["", "1", "", "", "5", "", "3", "", "", "4", "", "", "", "", "", "6", ""]
      expect(coref_ids).to eq ["", "1", "", "", "3", "", "4", "", "", "2", "", "", "", "", "", "5", ""]
    end
  end

  it "should use custom properties when set" do
    StanfordCoreNLP.custom_properties['ssplit.isOneSentence'] = 'true'
    text = 'Little my says hi.  Moomin says hi as well.'
    pipeline = StanfordCoreNLP.load(:tokenize, :ssplit)
    annotation = StanfordCoreNLP::Annotation.new(text)
    pipeline.annotate(annotation)
    expect(annotation.get(:sentences).size).to eq 1
  end

  it "should not use custom properties when not set" do
    StanfordCoreNLP.custom_properties = {}
    text = 'Little my says hi.  Moomin says hi as well.'
    pipeline = StanfordCoreNLP.load(:tokenize, :ssplit)
    annotation = StanfordCoreNLP::Annotation.new(text)
    pipeline.annotate(annotation)
    expect(annotation.get(:sentences).size).to eq 2
  end
end
