package org.swissbib.documentprocessing.flink.functions;

import org.apache.flink.api.common.functions.RichMapFunction;
import org.apache.flink.api.common.typeinfo.TypeInformation;
import org.apache.flink.api.common.typeinfo.Types;
import org.apache.flink.api.java.typeutils.ResultTypeQueryable;
import org.apache.flink.configuration.Configuration;
import org.swissbib.SbMetadataModel;
import org.swissbib.documentprocessing.flink.helper.PipeConfig;
import org.swissbib.documentprocessing.flink.helper.TemplateCreator;
import org.swissbib.documentprocessing.flink.helper.TemplateTransformer;
import org.swissbib.documentprocessing.flink.helper.XSLTDataObject;

import javax.xml.transform.Transformer;
import java.util.regex.Pattern;

public class MapStartFunction extends RichMapFunction<SbMetadataModel, XSLTDataObject>
         {

    private PipeConfig pipeConfig;

    private Transformer transformer;

    private static Pattern p = Pattern.compile("<record .*?>");

    public MapStartFunction(PipeConfig pipeConfig) {
        this.pipeConfig = pipeConfig;
    }


    @Override
    public XSLTDataObject map(SbMetadataModel value) throws Exception {

        String rawData = value.getData();
        String noNS = p.matcher(rawData).replaceAll("<record>");

        String holdings = new TemplateTransformer(noNS).transform(transformer);
        XSLTDataObject daobject  =  new XSLTDataObject();
        daobject.additions.put("holdingsStructure",holdings);
        daobject.record = noNS;

        return daobject;
    }

    @Override
    public void open(Configuration parameters) throws Exception {
        super.open(parameters);
        createStartTransformer();
    }

    @Override
    public void close() throws Exception {
        super.close();
    }


    protected void createStartTransformer() {

        String startTemplate = pipeConfig.getXsltTemplates().get("startTemplate").get("holdingsStructure");
        String xsltFactory = pipeConfig.getXsltTemplates().get("simpleValues").get("TRANSFORMERIMPL");

        transformer = new TemplateCreator(xsltFactory, startTemplate).createTransformerFromResource();
    }


}
