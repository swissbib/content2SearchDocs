package org.swissbib.documentprocessing;
import org.metafacture.framework.MetafactureException;
import org.swissbib.metafacture.xml.xslt.XSLTPipeStart;
import org.swissbib.metafacture.xml.xslt.helper.PipeConfig;

import java.util.Optional;


public class MFXsltBasedBridge {


    private MFXsltBasedBridge singleBridge = null;

    private PipeConfig pipeConfig = null;
    private String pipeConfigName = "pipeDefaultConfig.yaml";
    private String transformerFactory = "net.sf.saxon.TransformerFactoryImpl";

    private XSLTPipeStart pipe = null;

    public MFXsltBasedBridge build() {

        if (null == this.singleBridge) {
            return new MFXsltBasedBridge();
        } else {
            return this.singleBridge;
        }

    }

    public MFXsltBasedBridge setPipeConfig(PipeConfig config) {
        this.pipeConfig = config;
        return singleBridge;
    }

    public MFXsltBasedBridge setConfigFileName(String fileName) {
        this.pipeConfigName = fileName;
        return singleBridge;
    }

    public MFXsltBasedBridge setTransformerFactory(String fileName) {
        this.transformerFactory = fileName;
        return singleBridge;
    }


    private MFXsltBasedBridge() {}


    public void init () throws MetafactureException {

        //at the moment we use only a file name
        if (null == this.pipeConfigName) {
            throw new MetafactureException("no pipe config provided");
        }

        XSLTPipeStart pipeStart = new XSLTPipeStart();
        pipeStart.setConfigFile(this.pipeConfigName);
        pipeStart.setTransformerFactory(this.transformerFactory);

        this.pipe = pipeStart;

    }

    public String transform(String content) {
        this.pipe.process(content);

        Optional<String> tR = this.pipe.getTransformationResultOfPipe();
        return tR.orElse("");
    }

}
