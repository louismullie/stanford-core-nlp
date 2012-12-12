require 'stanford-core-nlp/config'

module StanfordCoreNLP

  VERSION = '0.3.5'

  if RUBY_PLATFORM =~ /java/
    require 'stanford-core-nlp/bind_it_stub'
    extend BindItStub

    require 'stanford-core-nlp/jruby_binding'
    extend JrubyBinding
  else
    require 'bind-it'
    extend BindIt::Binding

    require 'stanford-core-nlp/mri_binding'
    extend MriBinding
  end

  # ############################ #
  # BindIt Configuration Options #
  # ############################ #
  
  # The default path for the JAR files 
  # is the gem's bin folder.
  self.jar_path = File.dirname(__FILE__).gsub(/\/lib\z/, '') + '/deps/'
    
  # Default namespace is the Stanford pipeline namespace.
  self.default_namespace = 'edu.stanford.nlp.pipeline'
  
  # ########################### #
  # Stanford Core NLP bindings  #
  # ########################### #
    
  class << self
    # The model file names for a given language.
    attr_accessor :model_files
    # The folder in which to look for models.
    attr_accessor :model_path
    # Store the language currently being used.
    attr_accessor :language
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
    self.language = lang
    Config::Models.each do |n, languages|
      models = languages[lang]
      folder = Config::ModelFolders[n]
      if models.is_a?(Hash)
        n = n.to_s
        n += '.model' if n == 'ner'
        models.each do |m, file|
          self.model_files["#{n}.#{m}"] = folder + file
        end
      elsif models.is_a?(String)
        self.model_files["#{n}.model"] = folder + models
      end
    end
  end

  # Use english by default.
  self.use :english

  # Set a model file. 
  def self.set_model(name, file)
    n = name.split('.')[0].intern
    self.model_files[name] = Config::ModelFolders[n] + file
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

  # Returns true if we're running on Windows.
  def self.running_on_windows?
    RUBY_PLATFORM.split("-")[1] == 'mswin32'
  end

end