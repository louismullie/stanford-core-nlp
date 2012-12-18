module StanfordCoreNLP::Bridge

  unless RUBY_PLATFORM =~ /java/
    StanfordCoreNLP.default_classes <<  ['AnnotationBridge', '']
  end
  
  def inject_get_method(klass)
    
    klass.class_eval do
      
      if RUBY_PLATFORM =~ /java/
        return unless method_defined?(:get)
        alias_method :get_without_casting, :get
      end

      # Dynamically defined on all proxied annotation classes.
      # Get an annotation using the annotation bridge.
      def get(annotation, anno_base = nil)

        unless RUBY_PLATFORM =~ /java/
          return unless java_methods.include?('get(Ljava.lang.Class;)')
        end
        
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
          msg = "There are many different annotations bearing the name #{anno_class}." +
          "\nPlease specify one of the following base classes as second parameter to disambiguate: "
          msg << anno_bases.join(',')
          raise msg
        else
          base_class = anno_bases[0]
        end

        if RUBY_PLATFORM =~ /java/
          fqcn = "edu.stanford.#{base_class}"
          class_path = fqcn.split(".")
          class_name = class_path.pop
          path = StanfordCoreNLP.camel_case(class_path.join("."))
          jruby_class = "Java::#{path}::#{class_name}::#{anno_class}"
          get_without_casting(Object.module_eval(jruby_class))
        else
          url = "edu.stanford.#{base_class}$#{anno_class}"
          StanfordCoreNLP::AnnotationBridge.getAnnotation(self, url)
        end
        
      end

    end
    
  end

end
