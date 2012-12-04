import edu.stanford.nlp.ling.CoreAnnotation;
import edu.stanford.nlp.util.ArrayCoreMap;

public class AnnotationBridge {
    
    public static Object getAnnotation(Object entity, String name) throws ClassNotFoundException {
    	Class<CoreAnnotation> klass;
    	klass = (Class<CoreAnnotation>) Class.forName(name);
    	Object object = ((ArrayCoreMap) entity).get(klass);
		return object;
    }
}