module StanfordCoreNLP

  VERSION = '0.1.4'
  require 'stanford-core-nlp/jar_loader.rb'
  require 'stanford-core-nlp/java_wrapper'
  require 'stanford-core-nlp/stanford_annotations'
    
  class << self
    # The path in which to look for the Stanford JAR files.
    # This is passed to JarLoader.
    attr_accessor :jar_path
    # The flags for starting the JVM machine.
    # Parser and named entity recognizer are very memory consuming.
    attr_accessor :jvm_args
    # A file to redirect JVM output to.
    attr_accessor :log_file
    # The model files. Use #set_model to modify these.
    attr_accessor :model_files
  end

  # The default JAR path is the gem's bin folder.
  self.jar_path = File.dirname(__FILE__) + '/../bin/'
  # Load the JVM with a minimum heap size of 512MB and a 
  # maximum heap size of 1024MB.
  self.jvm_args = ['-Xms512M', '-Xmx1024M']
  # Turn logging off by default.
  self.log_file = nil
  
  # Default model files.
  self.model_files = {
    'pos.model' => 'taggers/english-left3words-distsim.tagger',
    'ner.model.3class' => 'classifiers/all.3class.distsim.crf.ser.gz',
    'ner.model.7class' => 'classifiers/muc.7class.distsim.crf.ser.gz',
    'ner.model.MISCclass' => 'classifiers/conll.4class.distsim.crf.ser.gz',
    'parser.model' => 'grammar/englishPCFG.ser.gz',
    'dcoref.demonym' => 'dcoref/demonyms.txt',
    'dcoref.animate' => 'dcoref/animate.unigrams.txt',
    'dcoref.female' => 'dcoref/female.unigrams.txt',
    'dcoref.inanimate' => 'dcoref/inanimate.unigrams.txt',
    'dcoref.male' => 'dcoref/male.unigrams.txt',
    'dcoref.neutral' => 'dcoref/neutral.unigrams.txt',
    'dcoref.plural' => 'dcoref/plural.unigrams.txt',
    'dcoref.singular' => 'dcoref/singular.unigrams.txt',
    'dcoref.states' => 'dcoref/state-abbreviations.txt',
    'dcoref.countries' => 'dcoref/unknown.txt',     # Fix - can somebody provide this file?
    'dcoref.states.provinces' => 'dcoref/unknown.txt',   # Fix - can somebody provide this file?
    'dcoref.extra.gender' => 'dcoref/namegender.combine.txt'
  }
  
  # Whether the classes are initialized or not.
  @@initialized = false
  # Whether the jars are loaded or not.
  @@loaded = false
  
  # Set a model file.
  def self.set_model(name, file)
    unless File.readable?(self.jar_path + file)
      raise "JAR file #{self.jar_path + file} could not be found." +
      "You may need to download this file manually and/or set paths properly."
    end
    self.model_files[name] = file
  end

  # Load the JARs, create the classes.
  def self.init
    self.load_jars unless @@loaded
    self.create_classes
    @@initialized = true
  end
  
  # Load a StanfordCoreNLP pipeline with the specified JVM flags and
  # StanfordCoreNLP properties (hash of property => values).
  def self.load(*annotators)
    self.init unless @@initialized
    # Prepend the JAR path to the model files.
    properties = {}
    self.model_files.each { |k,v| properties[k] = self.jar_path + v }
    properties['annotators'] = 
    annotators.map { |x| x.to_s }.join(', ')
    CoreNLP.new(get_properties(properties))
  end

  # Load the jars.
  def self.load_jars
    JarLoader.jvm_args = self.jvm_args
    JarLoader.jar_path = self.jar_path
    JarLoader.log(self.log_file) if self.log_file
    JarLoader.load('joda-time.jar')
    JarLoader.load('xom.jar')
    JarLoader.load('stanford-corenlp.jar')
    JarLoader.load('bridge.jar')
    @@loaded = true
  end

  # Create the Ruby classes corresponding to the StanfordNLP
  # core classes.
  def self.create_classes
    const_set(:CoreNLP, Rjb::import('edu.stanford.nlp.pipeline.StanfordCoreNLP'))
    const_set(:Annotation, Rjb::import('edu.stanford.nlp.pipeline.Annotation'))
    const_set(:Text, Annotation) # A more intuitive alias.
    const_set(:Properties, Rjb::import('java.util.Properties'))
    const_set(:AnnotationBridge, Rjb::import('AnnotationBridge'))
  end
  
  # Load a class (e.g. PTBTokenizerAnnotator) in a specific
  # class path (default is 'edu.stanford.nlp.pipeline').
  # The class is then accessible under the StanfordCoreNLP
  # namespace, e.g. StanfordCoreNLP::PTBTokenizerAnnotator.
  def self.load_class(klass, base = 'edu.stanford.nlp.pipeline')
    self.load_jars unless @@loaded
    const_set(klass.intern, Rjb::import("#{base}.#{klass}"))
  end
  
  # Create a java.util.Properties object from a hash.
  def self.get_properties(properties)
    props = Properties.new
    properties.each do |property, value|
      props.set_property(property, value)
    end
    props
  end
  
  # Helper function: under_case -> CamelCase.
  def self.camel_case(text)
    text.to_s.gsub(/^[a-z]|_[a-z]/) { |a| a.upcase }.gsub('_', '')
  end
  
end