require 'stanford-core-nlp/bridge'

module MriBinding

  # Load the JVM with a minimum heap size of 512MB,
  # and a maximum heap size of 1024MB.
  StanfordCoreNLP.jvm_args = ['-Xms512M', '-Xmx1024M']
  
  # Turn logging off by default.
  StanfordCoreNLP.log_file = nil
  
  # Default JAR files to load.
  StanfordCoreNLP.default_jars = [
    'joda-time.jar', 
    'xom.jar', 
    'stanford-parser.jar',
    'stanford-corenlp.jar', 
    'bridge.jar'
  ]
  
  # Default classes to load.
  StanfordCoreNLP.default_classes = [
    ['StanfordCoreNLP', 'edu.stanford.nlp.pipeline', 'CoreNLP'],
    ['Annotation', 'edu.stanford.nlp.pipeline', 'Text'],
    ['Word', 'edu.stanford.nlp.ling'],
    ['MaxentTagger', 'edu.stanford.nlp.tagger.maxent'],
    ['CRFClassifier', 'edu.stanford.nlp.ie.crf'],
    ['Properties', 'java.util'],
    ['ArrayList', 'java.util'],
    ['AnnotationBridge', '']
  ]

  # Load a StanfordCoreNLP pipeline with the
  # specified JVM flags and StanfordCoreNLP
  # properties.
  def load(*annotators)
    
    # Take care of Windows users.
    if self.running_on_windows?
      self.jar_path.gsub!('/', '\\')
      self.model_path.gsub!('/', '\\')
    end
    
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
        raise "Model file #{f} could not be found. You may need to download this file manually and/or set paths properly."
      end
      properties[k] = f
    end

    # Bug fix for French/German parser due to Stanford bug.
    # Otherwise throws IllegalArgumentException: 
    # Unknown option: -retainTmpSubcategories
    if self.language == :french || self.language == :german
      properties['parser.flags'] = ''
    end
    
    properties['annotators'] = annotators.map { |x| x.to_s }.join(', ')
    
    StanfordCoreNLP::CoreNLP.new(get_properties(properties))
  end

end