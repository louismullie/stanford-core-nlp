import edu.stanford.nlp.ling.CoreAnnotation;
import edu.stanford.nlp.util.ArrayCoreMap;
import java.util.Properties;
import edu.stanford.nlp.pipeline.StanfordCoreNLP;

// javac -cp '.:stanford-corenlp.jar' -source 1.6 -target 1.6 AnnotationBridge.java
// jar cf bridge.jar AnnotationBridge.class
public class AnnotationBridge {
    
    public static Object getAnnotation(Object entity, String name) throws ClassNotFoundException {
      Class<CoreAnnotation> klass;
      klass = (Class<CoreAnnotation>) Class.forName(name);
      Object object = ((ArrayCoreMap) entity).get(klass);
      return object;
    }
    
    public static Object getPipelineWithProperties(Properties properties) {
      StanfordCoreNLP pipeline = new StanfordCoreNLP(properties);
      return pipeline;
    }
}