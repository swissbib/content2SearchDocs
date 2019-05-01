package org.swissbib.metafacture.xml.xslt;

import org.metafacture.framework.ObjectReceiver;
import org.metafacture.framework.helpers.DefaultObjectPipe;
import org.swissbib.metafacture.xml.xslt.helper.TemplateCreator;
import org.swissbib.metafacture.xml.xslt.helper.TemplateTransformer;


import javax.xml.transform.*;

public class XSLTPipeStep extends DefaultObjectPipe<XSLTDataObject, ObjectReceiver<XSLTDataObject>> {

    protected String templatePath;
    protected Transformer transformer;

    private String transformerFactory = null;

    private boolean firstTransformation = true;


    public String getTransformerFactory() {
        return transformerFactory;
    }

    public void setTransformerFactory(String transformerFactory) {
        //System.setProperty("javax.xml.transform.TransformerFactory","net.sf.saxon.TransformerFactoryImpl");
        this.transformerFactory = transformerFactory;
    }


    public void setTemplate(String templatePath) {

        this.templatePath = templatePath;
    }




    @Override
    public void process(XSLTDataObject obj) {

        if (firstTransformation) {
            firstTransformation = false;
            //init();

            transformer = transformerFactory != null ?
                    new TemplateCreator(transformerFactory,
                            templatePath).createTransformer() :
                    new TemplateCreator( templatePath).createTransformerFromResource();

        }

        XSLTDataObject dataObject = new TemplateTransformer(obj.record).transformIntoDataObject(transformer);
        //handover the additions to the next step. They wil be used in last step of the pipe
        dataObject.additions = obj.additions;
        getReceiver().process(dataObject);

    }


}
