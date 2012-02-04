module StanfordCoreNLP

  # Modify the Rjb JavaProxy class to add our own methods to every Java object.
  Rjb::Rjb_JavaProxy.class_eval do

    # Dynamically defined on all proxied Java objects.
    # Shorthand for to_string defined by Java classes.
    def to_s; to_string; end

    # Dynamically defined on all proxied Java iterators.
    # Provide Ruby-style iterators to wrap Java iterators.
    def each
      if !java_methods.include?('iterator()')
        raise 'This object cannot be iterated.'
      else
        i = self.iterator
        while i.has_next; yield i.next; end
      end
    end

    # Dynamically defined on all proxied annotation classes.
    # Get an annotation using the annotation bridge.
    def get(annotation, anno_base = nil)
      if !java_methods.include?('get(Ljava.lang.Class;)')
        raise'No annotation can be retrieved on this object.'
      else
        anno_class = "#{StanfordCoreNLP.camel_case(annotation)}Annotation"
        if anno_base
          raise "The path #{anno_base} doesn't exist." unless Annotations[anno_base]
          anno_bases = [anno_base]
        else
          anno_bases = Config::AnnotationsByName[anno_class]
          raise "The annotation #{anno_class} doesn't exist." unless anno_bases
        end
        if anno_bases.size > 1
          msg = "There are many different annotations bearing the name #{anno_class}. "
          msg << "Please specify one of the following base classes as second parameter to disambiguate: "
          msg << anno_bases.join(',')
          raise msg
        else
          base_class = anno_bases[0]
        end
        url = "edu.stanford.#{base_class}$#{anno_class}"
        AnnotationBridge.getAnnotation(self, url)
      end
    end
    
  end
end
