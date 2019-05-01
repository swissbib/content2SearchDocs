package org.swissbib.metafacture.xml.xslt;

import org.metafacture.framework.ObjectReceiver;
import org.metafacture.framework.helpers.DefaultObjectPipe;
import org.swissbib.metafacture.xml.xslt.helper.TemplateCreator;
import org.swissbib.metafacture.xml.xslt.helper.TemplateTransformer;
import javax.xml.transform.Transformer;

public class XSLTSimpleStep extends DefaultObjectPipe<String, ObjectReceiver<String>> {

    protected String templatePath;
    protected Transformer transformer;

    private String transformerFactory = null;

    private boolean firstTransformation = true;


    public void setTransformerFactory(String transformerFactory) {
        this.transformerFactory = transformerFactory;
    }


    public void setTemplate(String templatePath) {
        this.templatePath = templatePath;
    }


    @Override
    public void process(String obj) {

        if (firstTransformation) {
            firstTransformation = false;
            transformer = transformerFactory != null ?
                    new TemplateCreator(transformerFactory,
                            templatePath).createTransformer() :
                    new TemplateCreator( templatePath).createTransformer();
        }
        getReceiver().process(new TemplateTransformer(obj).transform(transformer));
    }
}
