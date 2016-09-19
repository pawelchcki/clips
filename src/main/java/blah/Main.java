package blah;

import com.google.common.base.Utf8;
import com.google.common.io.ByteSource;
import com.google.common.io.Resources;
import net.sf.clipsrules.jni.Environment;
import net.sf.clipsrules.jni.Router;

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;

public class Main {
    public static void main(String... args) throws IOException {
        Path clips = Files.createTempDirectory("clipsrules");
        Path clipsJni = clips.resolve("libCLIPSJNI.so");

        ByteSource byteSource = Resources.asByteSource(Resources.getResource("native/libCLIPSJNI.so"));
        byteSource.copyTo(Files.newOutputStream(clipsJni));
        System.err.println(clipsJni);
        System.load(clipsJni.toFile().getAbsolutePath());

        Environment environment = new Environment();
        String s = Resources.toString(Resources.getResource("backwards_chaining.clp"), Charset.forName("UTF-8"));
        environment.loadFromString(s);
        environment.reset();
        environment.run();
    }
}
