package org.swissbib.metafacture.xml.xslt.helper;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import org.metafacture.framework.MetafactureException;
import org.swissbib.metafacture.xml.xslt.XSLTPipeStart;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;


public class TemplateCreator {

    private String templatePath;

    public TemplateCreator(String transformerFactory,
                           String templatePath) {
        this(templatePath);
        System.setProperty("javax.xml.transform.TransformerFactory",transformerFactory);
    }

    public TemplateCreator(String templatePath) {
        this.templatePath = templatePath;
        //as a more general solution we do not use net.sf.saxon.TransformerFactoryImpl as default
        //System.setProperty("javax.xml.transform.TransformerFactory","net.sf.saxon.TransformerFactoryImpl");

    }


    public Transformer createTransformer() {
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        StreamSource source = null;

        Transformer transformer = null;

        if (new File(templatePath).exists()) {
            source = new StreamSource(templatePath);
            try {
                transformer = transformerFactory.newTransformer(source);
            } catch (TransformerConfigurationException ex) {
                ex.printStackTrace();

            }
        }
        return transformer;
    }


    public Transformer createTransformerFromResource() {
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        StreamSource source = null;

        Transformer transformer = null;
        ClassLoader classLoader = TemplateCreator.class.getClassLoader();
        try (InputStream is =  classLoader.getResourceAsStream(templatePath)) {
            source = new StreamSource(is);
            transformer = transformerFactory.newTransformer(source);
        } catch (TransformerConfigurationException | IOException exc) {
            throw new MetafactureException(exc);
        }


        return transformer;
    }



}
