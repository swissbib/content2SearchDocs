package org.swissbib.documentprocessing.flink.helper;


import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.HashMap;

public class TemplateTransformer {

    private final StringReader record;

    public TemplateTransformer(String recordToTransform) {
        record = new StringReader(recordToTransform);
    }

    public XSLTDataObject transformIntoDataObject(Transformer transformer) {

        StringWriter transformedRecord = getTransformation(transformer);

        XSLTDataObject dataObject = new XSLTDataObject();
        dataObject.record = transformedRecord.toString();
        dataObject.additions = new HashMap<>();

        return dataObject;

    }

    public String transform(Transformer transformer) {

        StringWriter transformedRecord = getTransformation(transformer);
        return transformedRecord.toString();

    }

    StringWriter getTransformation(Transformer transformer) {
        Source source = new StreamSource(record);
        StringWriter transformedRecord = new StringWriter();
        StreamResult target = new StreamResult(transformedRecord);

        try {

            transformer.transform(source, target);
        } catch (TransformerException tex) {
            throw new RuntimeException(tex);
        }

        return transformedRecord;

    }



}
