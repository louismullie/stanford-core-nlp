module StanfordCoreNLP::JrubyBridge
  
  #### FIX - must list clazzes
  
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
