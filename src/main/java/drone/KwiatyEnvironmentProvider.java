package drone;

import com.google.common.base.Throwables;
import com.google.common.io.Resources;
import com.google.inject.name.Named;
import net.sf.clipsrules.jni.Environment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.inject.Inject;
import javax.inject.Provider;
import java.io.IOException;
import java.nio.charset.Charset;

public class KwiatyEnvironmentProvider implements Provider<Environment> {
    private static final Logger log = LoggerFactory.getLogger(Main.class);

    private final String resourceName;

    @Inject
    public KwiatyEnvironmentProvider(@Named("clp") String resourceName) {
        this.resourceName = resourceName;
    }

    @Override
    public Environment get() {
        Environment environment = new Environment();
        environment.loadFromString(getString(resourceName));
        return environment;
    }
    private static String getString(String fileName) {
        try {
            return Resources.toString(Resources.getResource(fileName), Charset.forName("UTF-8"));
        } catch (IOException e) {
            log.error("failed loading clp", e);
            throw Throwables.propagate(e);
        }
    }
}
