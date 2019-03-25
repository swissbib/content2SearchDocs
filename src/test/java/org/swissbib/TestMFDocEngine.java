package org.swissbib;

import org.junit.jupiter.api.Test;
import org.swissbib.metafacture.xml.xslt.XSLTPipeStart;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.Scanner;

public class TestMFDocEngine {

    @Test
    void firstTransformationWithTemplateStep1() {

        XSLTPipeStart ps = new XSLTPipeStart();

        //InputStream inputStream =
        //        Thread.currentThread().getContextClassLoader().
        //                getResourceAsStream("org/swissbib/documentprocessing/step1.xsl");
        try {
            //java.net.URL url = TestMFDocEngine.class.
            ClassLoader classLoader = new TestMFDocEngine().getClass().getClassLoader();

            File file = new File(classLoader.getResource
                    ("org/swissbib/documentprocessing/step1.xsl").getFile());
            String content = new String(Files.readAllBytes(file.toPath()));
            System.out.println(content);
        } catch (Exception exc) {
            exc.printStackTrace();
        }


    }

}
