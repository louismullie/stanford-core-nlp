**About**
  
This gem provides high-level Ruby bindings to the [Stanford Core NLP package](http://nlp.stanford.edu/software/corenlp.shtml), a set natural language processing tools for English, including tokenization, part-of-speech tagging, lemmatization, named entity recognition, parsing, and coreference resolution. 

**Installing**

1. Install the gem:

    gem install stanford-core-nlp

2. Download the Stanford Core NLP JAR and model files [here](http://louismullie.com/stanford-core-nlp-english.zip). Place the contents of the extracted archive inside the /bin/ folder of the stanford-core-nlp gem (typically this is /usr/local/lib/ruby/gems/1.9.1/gems/stanford-core-nlp-0.x/bin/). This package only includes model files for English; see below for information on adding model files for other languages.

**Configuration**

After installing and requiring the gem (`require 'stanford-core-nlp'`), you may want to set some configuration options (this, however, is not necessary). Here are some examples:

    # Set an alternative path to look for the JAR files
    # Default is gem's bin folder.
    StanfordCoreNLP.jar_path = '/path/'

    # Pass some alternative arguments to the Java VM.
    # Default is ['-Xms512M', '-Xmx1024M'].
    StanfordCoreNLP.jvm_args = ['-option1', '-option2']

    # Redirect VM output to log.txt
    StanfordCoreNLP.log_file = 'log.txt'

You may also want to load your own classes from the Stanford NLP to do more specific tasks. The gem provides an API to do this:

    # Default base class is edu.stanford.nlp.pipeline.
    StanfordCoreNLP.load('PTBTokenizerAnnotator')  
    puts StanfordCoreNLP::PTBTokenizerAnnotator.inspect
      # => #<Rjb::Edu_stanford_nlp_pipeline_PTBTokenizerAnnotator>

    # Here, we specify another base class.
    StanfordCoreNLP.load('MaxentTagger', 'edu.stanford.nlp.tagger') 
    puts StanfordCoreNLP::MaxentTagger.inspect
      # => <Rjb::Edu_stanford_nlp_tagger_maxent_MaxentTagger:0x007f88491e2020>

**Using the gem**

    text = 'Angela Merkel met Nicolas Sarkozy on January 25th in ' +
           'Berlin to discuss a new austerity package. Sarkozy ' +
           'looked pleased, but Merkel was dismayed.'

    pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, pos, :lemma, :parse, :ner, :dcoref)
    text = StanfordCoreNLP::Text.new(text)
    pipeline.annotate(text)

    text.get(:sentences).each do |sentence|
        sentence.get(:tokens).each do |token|
            # Default annotations for all tokens
            puts token.get(:value).to_s
            puts token.get(:original_text).to_s
            puts token.get(:character_offset_begin).to_s
            puts token.get(:character_offset_end).to_s
            # POS returned by the tagger
            puts token.get(:part_of_speech).to_s
            # Lemma (base form of the token)
            puts token.get(:lemma).to_s
            # Named entity tag
            puts token.get(:named_entity_tag).to_s
            # Coreference
            puts token.get(:coref_cluster_id).to_s
            # Also of interest: coref, coref_chain, coref_cluster, coref_dest, coref_graph.
        end
    end

A good reference for names of annotations are the Stanford Javadocs for [CoreAnnotations](http://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/ling/CoreAnnotations.html), [CoreCorefAnnotations](http://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/dcoref/CorefCoreAnnotations.html), and [TreeCoreAnnotations](http://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/trees/TreeCoreAnnotations.html). For a full list of all possible annotations, see the 'stanford_annotations.rb' file inside the gem. The Ruby symbol (e.g. :named_entity_tag) corresponding ot a Java annotation class follows the simple un-camel-casing convention, with 'Annotation' at the end removed. For example, the annotation NamedEntityTagAnnotation translates to :named_entity_tag, PartOfSpeechAnnotation to :part_of_speech, etc.

**Adding models for other languages for the parser and tagger**

- For the Stanford Parser, download the [parser files](http://nlp.stanford.edu/software/lex-parser.shtml), and copy from the grammar/ directory the grammars you need into the gem's bin/grammar directory (e.g. /usr/local/lib/ruby/gems/1.9.1/gems/stanford-core-nlp-0.x/bin/grammar). Grammars are available for Arabic, Chinese, French, German and Xinhua.
- For the Stanford Tagger, download the [tagger files](http://nlp.stanford.edu/software/tagger.shtml), and copy from the models/ directory the models you need into the gem's bin/models directory. Models are available for Arabic, Chinese, French and German.

Then, configure the gem to use your newly added files, e.g.:
    
    StanfordCoreNLP.set_model('parser.model', '/path/to/gem/bin/grammar/chinesePCFG.ser.gz')
    StanfordCoreNLP.set_model('tagger.model', '/path/to/gem/bin/grammar/chinese.tagger')
    pipeline =  StanfordCoreNLP.load(:ssplit, :tokenize, :pos, :parse)

**Current known issues**

The models included with the gem for the NER system are missing two files: "edu/stanford/nlp/models/dcoref/countries" and "edu/stanford/nlp/models/dcoref/statesandprovinces", which I couldn't find anywhere. I will be very grateful if somebody could add/e-mail me these files.

**Contributing**

Feel free to fork the project and send me a pull request!