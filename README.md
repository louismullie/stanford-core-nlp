**About**
  
This gem provides high-level Ruby bindings to the [Stanford Core NLP package](http://nlp.stanford.edu/software/corenlp.shtml), a set natural language processing tools for tokenization, sentence segmentation, part-of-speech tagging, lemmatization, and parsing of English, French and German. The package also provides named entity recognition and coreference resolution for English. This gem is compatible with JRuby 1.7.1 and above, as well as Ruby 1.9.2 and 1.9.3 (through Rjb). Please note that from 0.4.3 on, JRuby 1.6.7.2 is no longer supported.

This gem only provides a thin wrapper over the Stanford Core NLP API. If you are looking for a Ruby natural language processing framework, have a look at [Treat](https://github.com/louismullie/treat).

**Installing**

_Note: If you are running on MRI, this gem will use the Ruby-Java Bridge (Rjb), which currently does not support Java 7. Therefore, if you have installed Java 7, you should set your JAVA_HOME to point to your old Java 6 install before installing Rjb; for example, `export "JAVA_HOME=/usr/lib/jvm/java-6-openjdk/"`._

First, install the gem: `gem install stanford-core-nlp`. Then, download the Stanford Core NLP JAR and model files. Three different packages are available:

* A [minimal package](http://louismullie.com/treat/stanford-core-nlp-minimal.zip) with the default tagger and parser models for English, French and German.
* A [full package](http://louismullie.com/treat/stanford-core-nlp-all.zip), with all of the tagger and parser models for English, French and German, as well as named entity and coreference resolution models for English.

Place the contents of the extracted archive inside the /bin/ folder of the stanford-core-nlp gem (e.g. [...]/gems/stanford-core-nlp-0.x/bin/).

**Configuration**

After installing and requiring the gem (`require 'stanford-core-nlp'`), you may want to set some optional configuration options. Here are some examples:

```ruby
# Set an alternative path to look for the JAR files
# Default is gem's bin folder.
StanfordCoreNLP.jar_path = '/path_to_jars/'

# Set an alternative path to look for the model files
# Default is gem's bin folder.
StanfordCoreNLP.model_path = '/path_to_models/'

# Pass some alternative arguments to the Java VM.
# Default is ['-Xms512M', '-Xmx1024M'] (be prepared
# to take a coffee break).
StanfordCoreNLP.jvm_args = ['-option1', '-option2']

# Redirect VM output to log.txt
StanfordCoreNLP.log_file = 'log.txt'

# Use the model files for a different language than English.
StanfordCoreNLP.use(:french) # or :german

# Change a specific model file.
StanfordCoreNLP.set_model('pos.model', 'english-left3words-distsim.tagger')
```

**Using the gem**

```ruby
text = 'Angela Merkel met Nicolas Sarkozy on January 25th in ' +
   'Berlin to discuss a new austerity package. Sarkozy ' +
   'looked pleased, but Merkel was dismayed.'

pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref)
text = StanfordCoreNLP::Annotation.new(text)
pipeline.annotate(text)

text.get(:sentences).each do |sentence|
  # Syntatical dependencies
  puts sentence.get(:basic_dependencies).to_s
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

> Important: You need to load the StanfordCoreNLP pipeline before using the StanfordCoreNLP::Annotation class.

A good reference for names of annotations are the Stanford Javadocs for [CoreAnnotations](http://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/ling/CoreAnnotations.html), [CoreCorefAnnotations](http://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/dcoref/CorefCoreAnnotations.html), and [TreeCoreAnnotations](http://nlp.stanford.edu/nlp/javadoc/javanlp/edu/stanford/nlp/trees/TreeCoreAnnotations.html). For a full list of all possible annotations, see the 'config.rb' file inside the gem. The Ruby symbol (e.g. `:named_entity_tag`) corresponding to a Java annotation class follows the simple un-camel-casing convention, with 'Annotation' at the end removed. For example, the annotation `NamedEntityTagAnnotation` translates to `:named_entity_tag`, `PartOfSpeechAnnotation` to `:part_of_speech`, etc.

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

**List of annotator classes**

Here is a full list of annotator classes provided by the Stanford Core NLP package. You can load these classes individually using `StanfordCoreNLP.load_class` (see above). Once this is done, you can use them like you would from a Java program. Refer to the Java documentation for a list of functions provided by each of these classes.

* PTBTokenizerAnnotator - tokenizes the text following Penn Treebank conventions.
* WordToSentenceAnnotator - splits a sequence of words into a sequence of sentences.
* POSTaggerAnnotator - annotates the text with part-of-speech tags.
* MorphaAnnotator - morphological normalizer (generates lemmas).
* NERAnnotator - annotates the text with named-entity labels.
* NERCombinerAnnotator - combines several NER models.
* TrueCaseAnnotator - detects the true case of words in free text.
* ParserAnnotator - generates constituent and dependency trees.
* NumberAnnotator - recognizes numerical entities such as numbers, money, times, and dates.
* TimeWordAnnotator - recognizes common temporal expressions, such as "teatime".
* QuantifiableEntityNormalizingAnnotator - normalizes the content of all numerical entities.
* SRLAnnotator - annotates predicates and their semantic roles.
* DeterministicCorefAnnotator - implements anaphora resolution using a deterministic model.
* NFLAnnotator - implements entity and relation mention extraction for the NFL domain.

**List of model files**

Here is a full list of the default models for the Stanford Core NLP pipeline. You can change these models individually using `StanfordCoreNLP.set_model` (see above).

* 'pos.model' - 'english-left3words-distsim.tagger'
* 'ner.model.3class' - 'all.3class.distsim.crf.ser.gz'
* 'ner.model.7class' - 'muc.7class.distsim.crf.ser.gz'
* 'ner.model.MISCclass' -- 'conll.4class.distsim.crf.ser.gz'
* 'parse.model' - 'englishPCFG.ser.gz'
* 'dcoref.demonym' - 'demonyms.txt'
* 'dcoref.animate' - 'animate.unigrams.txt'
* 'dcoref.female' - 'female.unigrams.txt'
* 'dcoref.inanimate' - 'inanimate.unigrams.txt'
* 'dcoref.male' - 'male.unigrams.txt'
* 'dcoref.neutral' - 'neutral.unigrams.txt'
* 'dcoref.plural' - 'plural.unigrams.txt'
* 'dcoref.singular' - 'singular.unigrams.txt'
* 'dcoref.states' - 'state-abbreviations.txt'
* 'dcoref.extra.gender' - 'namegender.combine.txt'

**Contributing**

Feel free to fork the project and send me a pull request!