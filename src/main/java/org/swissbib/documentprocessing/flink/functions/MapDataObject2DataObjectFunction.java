package org.swissbib.documentprocessing.flink.functions;

import org.apache.flink.api.common.functions.RichMapFunction;
import org.apache.flink.configuration.Configuration;
import org.swissbib.documentprocessing.flink.helper.PipeConfig;
import org.swissbib.documentprocessing.flink.helper.TemplateCreator;
import org.swissbib.documentprocessing.flink.helper.TemplateTransformer;
import org.swissbib.documentprocessing.flink.helper.XSLTDataObject;

import javax.xml.transform.Transformer;

public class MapDataObject2DataObjectFunction extends RichMapFunction<XSLTDataObject, XSLTDataObject> {

    private PipeConfig pipeConfig;
    private String templateName;
    private Transformer transformer;

    public MapDataObject2DataObjectFunction(PipeConfig pipeConfig,
                                            String templateName) {
        this.pipeConfig = pipeConfig;
        this.templateName = templateName;

    }

    @Override
    public XSLTDataObject map(XSLTDataObject value) throws Exception {

        String test = value.record;
        String newRecord = new TemplateTransformer(test).transform(transformer);

        XSLTDataObject xslt =  new XSLTDataObject();
        xslt.record = newRecord;
        xslt.additions = value.additions;

        return xslt;

    }

    @Override
    public void open(Configuration parameters) throws Exception {
        super.open(parameters);
        createPipeTransformer();
    }

    @Override
    public void close() throws Exception {
        super.close();
    }

    protected void createPipeTransformer() {

        String pipeTemplate = pipeConfig.getXsltTemplates().get("XSLT_PIPE").get(templateName);
        String xsltFactory = pipeConfig.getXsltTemplates().get("simpleValues").get("TRANSFORMERIMPL");

        System.out.println("creating template - name: " + pipeTemplate  );
        transformer = new TemplateCreator(xsltFactory, pipeTemplate).createTransformerFromResource();
    }



}
