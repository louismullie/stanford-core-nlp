module StanfordCoreNLP

  VERSION = '0.3.0'

  require 'bind-it'
  extend BindIt::Binding
  
  # 
  # BindIt Configuration Options
  #
  
  # The path in which to look for the Stanford JAR files,
  # with a trailing slash.
  self.jar_path = File.dirname(__FILE__) + '/../bin/'
  
  # Load the JVM with a minimum heap size of 512MB,
  # and a maximum heap size of 1024MB.
  self.jvm_args = ['-Xms512M', '-Xmx1024M']
  
  # Turn logging off by default.
  self.log_file = nil
  
  # Default JAR files to load.
  self.default_jars = [
    'joda-time.jar', 
    'xom.jar', 
    'stanford-corenlp.jar', 
    'bridge.jar'
  ]
  
  # Default classes to load.
  self.default_classes = [
    ['StanfordCoreNLP', 'edu.stanford.nlp.pipeline', 'CoreNLP'],
    ['Annotation', 'edu.stanford.nlp.pipeline', 'Text'],
    ['Word', 'edu.stanford.nlp.ling'],
    ['MaxentTagger', 'edu.stanford.nlp.tagger.maxent'],
    ['CRFClassifier', 'edu.stanford.nlp.ie.crf'],
    ['Properties', 'java.util'],
    ['ArrayList', 'java.util'],
    ['AnnotationBridge', '']
  ]
  
  # Default namespace is the Stanford pipeline namespace.
  self.default_namespace = 'edu.stanford.nlp.pipeline'

  require 'stanford-core-nlp/config'
  require 'stanford-core-nlp/bridge'
  
  class << self
    # The model file names for a given language.
    attr_accessor :model_files
    # The folder in which to look for models.
    attr_accessor :model_path
  end
  
  # The path to the main folder containing the folders
  # with the individual models inside. By default, this
  # is the same as the JAR path.
  self.model_path = self.jar_path

  # Use models for a given language. Language can be
  # supplied as full-length, or ISO-639 2 or 3 letter
  # code (e.g. :english, :eng or :en will work).
  def self.use(language)
    lang = nil
    self.model_files = {}
    Config::LanguageCodes.each do |l,codes|
      lang = codes[2] if codes.include?(language)
    end
    Config::Models.each do |n, languages|
      models = languages[lang]
      folder = Config::ModelFolders[n]
      if models.is_a?(Hash)
        n = n.to_s
        n += '.model' if n == 'ner'
        models.each do |m, file|
          self.model_files["#{n}.#{m}"] =
          folder + file
        end
      elsif models.is_a?(String)
        self.model_files["#{n}.model"] =
        folder + models
      end
    end
  end

  # Use english by default.
  self.use(:english)

  # Set a model file. 
  def self.set_model(name, file)
    n = name.split('.')[0].intern
    self.model_files[name] =
    Config::ModelFolders[n] + file
  end

  # Load a StanfordCoreNLP pipeline with the
  # specified JVM flags and StanfordCoreNLP
  # properties.
  def self.load(*annotators)
    
    # Make the bindings.
    self.bind
    # Prepend the JAR path to the model files.
    properties = {}
    self.model_files.each do |k,v|
      found = false
      annotators.each do |annotator|
        found = true if k.index(annotator.to_s)
        break if found
      end
      next unless found
      f = self.model_path + v
      unless File.readable?(f)
        raise "Model file #{f} could not be found. " +
        "You may need to download this file manually "+
        " and/or set paths properly."
      end
      properties[k] = f
    end

    properties['annotators'] =
    annotators.map { |x| x.to_s }.join(', ')
    CoreNLP.new(get_properties(properties))
  end

  # Create a java.util.Properties object from a hash.
  def self.get_properties(properties)
    props = Properties.new
    properties.each do |property, value|
      props.set_property(property, value)
    end
    props
  end

  # Get a Java ArrayList binding to pass lists
  # of tokens to the Stanford Core NLP process.
  def self.get_list(tokens)
    list = StanfordCoreNLP::ArrayList.new
    tokens.each do |t|
      list.add(StanfordCoreNLP::Word.new(t.to_s))
    end
    list
  end

end