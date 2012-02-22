**About**
  
This gem provides high-level Ruby bindings to the [Stanford Core NLP package](http://nlp.stanford.edu/software/corenlp.shtml), a set natural language processing tools that provides tokenization, part-of-speech tagging, lemmatization, and parsing for five languages (English, French, German, Arabic and Chinese), as well as named entity recognition and coreference resolution for English.

**Installing**

1. Install the gem: `gem install stanford-core-nlp`.

2. Download the Stanford Core NLP JAR and model files. Two package are available with the necessary files: a package for [English only](http://louismullie.com/stanford-core-nlp-english.zip), or a package with models for [all languages](http://louismullie.com/stanford-core-nlp-all.zip). Place the contents of the extracted archive inside the /bin/ folder of the stanford-core-nlp gem (typically this is /usr/local/lib/ruby/gems/1.9.1/gems/stanford-core-nlp-0.x/bin/).

**Configuration**

After installing and requiring the gem (`require 'stanford-core-nlp'`), you may want to set some configuration options (this, however, is not necessary). Here are some examples:

```ruby
# Set an alternative path to look for the JAR files
# Default is gem's bin folder.
StanfordCoreNLP.jar_path = '/path_to_jars/'

# Set an alternative path to look for the model files
# Default is gem's bin folder.
StanfordCoreNLP.jar_path = '/path_to_models/'

# Pass some alternative arguments to the Java VM.
# Default is ['-Xms512M', '-Xmx1024M'] (be prepared
# to take a coffee break).
StanfordCoreNLP.jvm_args = ['-option1', '-option2']

# Redirect VM output to log.txt
StanfordCoreNLP.log_file = 'log.txt'

# Use the model files for a different language than English.
StanfordCoreNLP.use(:french)

# Change a specific model file.
StanfordCoreNLP.set_model('pos.model', 'english-left3words-distsim.tagger')
```

**Using the gem**

```ruby
text = 'Angela Merkel met Nicolas Sarkozy on January 25th in ' +
   'Berlin to discuss a new austerity package. Sarkozy ' +
   'looked pleased, but Merkel was dismayed.'

pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref)
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
```

> Note: You need to load the StanfordCoreNLP pipeline before using the StanfordCoreNLP::Text class.

A good reference for names of annotations are the Stanford Javadocs for [CoreAnnotations](http://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/ling/CoreAnnotations.html), [CoreCorefAnnotations](http://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/dcoref/CorefCoreAnnotations.html), and [TreeCoreAnnotations](http://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/trees/TreeCoreAnnotations.html). For a full list of all possible annotations, see the 'config.rb' file inside the gem. The Ruby symbol (e.g. :named_entity_tag) corresponding to a Java annotation class follows the simple un-camel-casing convention, with 'Annotation' at the end removed. For example, the annotation NamedEntityTagAnnotation translates to :named_entity_tag, PartOfSpeechAnnotation to :part_of_speech, etc.

**Loading specific classes**

You may also want to load your own classes from the Stanford NLP to do more specific tasks. The gem provides an API to do this:

```ruby
# Default base class is edu.stanford.nlp.pipeline.
StanfordCoreNLP.load_class('PTBTokenizerAnnotator')  
puts StanfordCoreNLP::PTBTokenizerAnnotator.inspect
  # => #<Rjb::Edu_stanford_nlp_pipeline_PTBTokenizerAnnotator>

# Here, we specify another base class.
StanfordCoreNLP.load_class('MaxentTagger', 'edu.stanford.nlp.tagger') 
puts StanfordCoreNLP::MaxentTagger.inspect
  # => <Rjb::Edu_stanford_nlp_tagger_maxent_MaxentTagger:0x007f88491e2020>
```

**Contributing**

Feel free to fork the project and send me a pull request!