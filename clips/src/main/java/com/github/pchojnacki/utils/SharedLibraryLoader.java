package com.github.pchojnacki.utils;

import com.google.common.base.Throwables;
import com.google.common.io.ByteSource;
import com.google.common.io.Resources;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
    private static final Logger log = LoggerFactory.getLogger(SharedLibraryLoader.class);

    public static void load() {
        try {
            Path clips = Files.createTempDirectory("clipsrules");
            Path clipsJni = clips.resolve("libCLIPSJNI.so");
            clipsJni.toFile().deleteOnExit();
            clips.toFile().deleteOnExit();

            ByteSource byteSource = Resources.asByteSource(Resources.getResource("native/libCLIPSJNI.so"));
            byteSource.copyTo(Files.newOutputStream(clipsJni));
            System.load(clipsJni.toFile().getAbsolutePath());
        } catch (IOException ex) {
            log.error("failed loading CLIPS JNI", ex);
            throw Throwables.propagate(ex);
        }
    }


}
