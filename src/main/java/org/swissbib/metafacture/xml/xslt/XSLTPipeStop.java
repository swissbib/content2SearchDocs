package org.swissbib.metafacture.xml.xslt;

import org.metafacture.framework.ObjectReceiver;
import org.metafacture.framework.helpers.DefaultObjectPipe;
import org.swissbib.metafacture.xml.xslt.helper.TemplateCreator;
import org.swissbib.metafacture.xml.xslt.helper.TemplateTransformer;

import javax.xml.transform.*;

public class XSLTPipeStop extends DefaultObjectPipe<XSLTDataObject, ObjectReceiver<String>> {

    protected String templatePath;
    protected Transformer transformer;

    private String transformerFactory = null;

    private boolean firstTransformation = true;


    public String getTransformerFactory() {
        return transformerFactory;
    }

    public void setTransformerFactory(String transformerFactory) {
        this.transformerFactory = transformerFactory;
    }


    public void setTemplate(String templatePath) {

        this.templatePath = templatePath;
    }

    @Override
    public void process(XSLTDataObject obj) {

        if (firstTransformation) {
            firstTransformation = false;

            transformer = transformerFactory != null ?
                    new TemplateCreator(transformerFactory,
                            templatePath).createTransformer() :
                    new TemplateCreator( templatePath).createTransformerFromResource();

        }

        //if there are any "additions" (key in the structure of the data object)
        //the related value of the key is set as parameter of the template
        //the template can then use it
        if (obj.additions.size() > 0) {
            obj.additions.forEach((paramKeq, paramValue) -> {
                transformer.setParameter(paramKeq,paramValue);
            });
        }

        XSLTDataObject dataObject = new TemplateTransformer(obj.record).transformIntoDataObject(transformer);
        getReceiver().process(dataObject.record);

    }

}
