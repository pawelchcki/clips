package com.github.pchojnacki.utils;

import com.google.common.io.ByteSource;
import com.google.common.io.Resources;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashSet;
import java.util.UUID;
import java.util.zip.CRC32;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

public class SharedLibraryLoader {
//    private static final Logger log = LoggerFactory

    public static void loadWithExceptions() throws IOException {
        Path clips = Files.createTempDirectory("clipsrules");
        Path clipsJni = clips.resolve("libCLIPSJNI.so");

        ByteSource byteSource = Resources.asByteSource(Resources.getResource("native/libCLIPSJNI.so"));
        byteSource.copyTo(Files.newOutputStream(clipsJni));
        System.err.println(clipsJni);
        System.load(clipsJni.toFile().getAbsolutePath());
    }

    public static void load() {

    }
}
