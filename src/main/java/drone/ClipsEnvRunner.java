package drone;

import com.google.inject.Singleton;
import net.sf.clipsrules.jni.Environment;

import javax.inject.Inject;
import java.util.function.Function;

@Singleton
public class ClipsEnvRunner extends Thread {

    private final Environment environment;
    private Boolean running = false;

    @Inject
    public ClipsEnvRunner(Environment environment) {
        this.environment = environment;
    }

    @Override
    public void run() {
        running = true;
        environment.reset();
        environment.run();
    }

    public Boolean isRunning() {
        return running;
    }

    public Environment getEnvironment() {
        return environment;
    }
}
