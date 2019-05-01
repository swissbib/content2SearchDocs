package org.swissbib.metafacture.xml.xslt;

import org.metafacture.io.IoWriterFactory;

import java.io.StringWriter;
import java.io.Writer;

public class StringWriterFactory implements IoWriterFactory {
    @Override
    public Writer createWriter() {
        return new StringWriter();
    }
}
