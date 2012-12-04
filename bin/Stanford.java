import edu.stanford.nlp.ling.CoreAnnotation;
import edu.stanford.nlp.ling.CoreLabel;

public class Stanford {
    
    public static Object getAnnotation(CoreLabel entity, String name) throws ClassNotFoundException{
    	Class<CoreAnnotation> klass;
    	klass = (Class<CoreAnnotation>) Class.forName(name);
    	Object object = entity.get(klass);
		return object;
    }

}