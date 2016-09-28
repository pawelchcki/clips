package drone;

import com.github.pchojnacki.utils.SharedLibraryLoader;
import com.google.inject.*;
import com.google.inject.name.Names;
import net.sf.clipsrules.jni.Environment;

public class Main extends AbstractModule {

    public static void main(String... args) {
        SharedLibraryLoader.load();
        Injector injector = Guice.createInjector(new Main());
        ClipsEnvRunner instance = injector.getInstance(ClipsEnvRunner.class);

        
        instance.start();
    }


    @Override
    protected void configure() {
        bind(String.class)
                .annotatedWith(Names.named("clp"))
                .toInstance("kwiaty.clp");
        bind(Environment.class).toProvider(KwiatyEnvironmentProvider.class);
    }
}
