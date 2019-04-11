package org.swissbib;

import org.junit.jupiter.api.Test;
import org.metafacture.io.FileOpener;
import org.metafacture.io.LineReader;
import org.metafacture.io.ObjectStdoutWriter;
import org.swissbib.metafacture.xml.xslt.XSLTPipeStart;
import org.swissbib.metafacture.xml.xslt.XSLTPipeStop;

import java.io.*;
import java.nio.file.Files;

public class TestMFDocEngine {

    @Test
    void firstTransformationWithTemplateStep1() throws Exception {

        ClassLoader classLoader = new TestMFDocEngine().getClass().getClassLoader();

        File startfile = new File(classLoader.getResource
                ("org/swissbib/documentprocessing/step1.xsl").getFile());
        File stopfile = new File(classLoader.getResource
                ("org/swissbib/documentprocessing/step2.xsl").getFile());
        //String content = new String(Files.readAllBytes(file.toPath()));
        //System.out.println(content);
        File datafile = new File(classLoader.getResource
                ("org/swissbib/documentprocessing/testfile.xml.gz").getFile());

        FileOpener fo = new FileOpener();
        LineReader lr = new LineReader();
        fo.setReceiver(lr);
        XSLTPipeStart ps = new XSLTPipeStart();
        ps.setTemplate(startfile.getAbsolutePath());
        ps.setTransformerFactory("net.sf.saxon.TransformerFactoryImpl");
        lr.setReceiver(ps);

        XSLTPipeStop pipeStop = new XSLTPipeStop();
        pipeStop.setTemplate(stopfile.getAbsolutePath());
        ObjectStdoutWriter<String> ow = new ObjectStdoutWriter<>();
        pipeStop.setReceiver(ow);

        ps.setReceiver(pipeStop);
        fo.process(datafile.getAbsolutePath());


    }

}
