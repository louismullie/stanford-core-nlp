module StanfordCoreNLP::RjbBridge

  # Modify the Rjb JavaProxy class to add our 
  # own methods to every Java object.
  Rjb::Rjb_JavaProxy.class_eval do

    # Dynamically defined on all proxied annotation classes.
    # Get an annotation using the annotation bridge.
    def get(annotation, anno_base = nil)
      if !java_methods.include?('get(Ljava.lang.Class;)')
        raise 'No annotation can be retrieved on this object.'
      else
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
          msg = "There are many different annotations " +
          "bearing the name #{anno_class}. \nPlease specify " +
          "one of the following base classes as second " +
          "parameter to disambiguate: "
          msg << anno_bases.join(',')
          raise msg
        else
          base_class = anno_bases[0]
        end
        url = "edu.stanford.#{base_class}$#{anno_class}"
        StanfordCoreNLP::AnnotationBridge.getAnnotation(self, url)
      end
    end
    
  end

end
