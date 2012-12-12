module JrubyBinding

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
    ['CoreLabel', 'edu.stanford.nlp.ling'],
    ['MaxentTagger', 'edu.stanford.nlp.tagger.maxent'],
    ['CRFClassifier', 'edu.stanford.nlp.ie.crf'],
    ['Properties', 'java.util'],
    ['ArrayList', 'java.util'],
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
    
    self.default_jars.each{|jar| require("#{jar_path}#{jar}")}

    self.default_classes.each do |clazz|
      fqcn = "#{clazz[1]}.#{clazz[0]}"

      java_import(fqcn)
      include_package(clazz[1])
      
      inject_get_method(module_eval("Java::#{camel_case(clazz[1])}.#{clazz[0]}"))

      if clazz.size == 3
        Object.const_set(clazz[2], module_eval("Java::#{camel_case(clazz[1])}.#{clazz[0]}"))
      end
    end

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
    
    properties['annotators'] =
    annotators.map { |x| x.to_s }.join(', ')
    
    CoreNLP.new(get_properties(properties))
  end

  # camel_case which also support dot as separator
  def camel_case(s)
    s.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_|\.)(.)/) { $1.upcase }
  end

  def inject_get_method(clazz)
    return unless clazz.method_defined?(:get)

    clazz.class_eval do

      # Dynamically defined on all proxied annotation classes.
      # Get an annotation using the annotation bridge.
      def get_with_casting(annotation, anno_base = nil)
        anno_class = "#{StanfordCoreNLP.camel_case(annotation)}Annotation"
        if anno_base
          unless StanfordNLP::Config::Annotations[anno_base]
            raise "The path #{anno_base} doesn't exist." 
          end
          anno_bases = [anno_base]
        else
          anno_bases = StanfordCoreNLP::Config::AnnotationsByName[anno_class]
          raise "The annotation #{anno_class} doesn't exist." unless anno_bases
        end
        if anno_bases.size > 1
          msg = "There are many different annotations bearing the name #{anno_class}. \nPlease specify one of the following base classes as second parameter to disambiguate: "
          msg << anno_bases.join(',')
          raise msg
        else
          base_class = anno_bases[0]
        end
    
        fqcn = "edu.stanford.#{base_class}"
        class_path = fqcn.split(".")
        class_name = class_path.pop
        jruby_class = "Java::#{StanfordCoreNLP.camel_case(class_path.join("."))}::#{class_name}::#{anno_class}"

        get_without_casting(Object.module_eval(jruby_class))
      end

      alias_method :get_without_casting, :get
      alias_method :get, :get_with_casting
    end
  end
end