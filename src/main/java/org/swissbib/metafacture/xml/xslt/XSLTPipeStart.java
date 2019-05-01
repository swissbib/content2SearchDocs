package org.swissbib.metafacture.xml.xslt;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import org.metafacture.framework.MetafactureException;
import org.metafacture.framework.ObjectReceiver;
import org.metafacture.framework.helpers.DefaultObjectPipe;
import org.metafacture.io.IoWriterFactory;
import org.swissbib.metafacture.xml.xslt.helper.PipeConfig;
import org.swissbib.metafacture.xml.xslt.helper.TemplateCreator;
import org.swissbib.metafacture.xml.xslt.helper.TemplateTransformer;
import org.swissbib.metafacture.xml.xslt.plugins.IXSLTPlugin;

import javax.xml.transform.*;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Optional;


public class XSLTPipeStart extends DefaultObjectPipe<String, ObjectReceiver<XSLTDataObject>> {


    //private String templatePath;
    //protected Transformer transformer = null;
    protected Transformer startTransformer = null;
    protected String startTransformerKey = "";

    private String configFile = null;
    private String transformerFactory = null;
    private boolean firstTransformation;
    protected PipeConfig pipeConfig = null;

    protected boolean selfContained;

    private ObjectJavaIoWriter<String> oIOWriter = null;

    protected ArrayList<IXSLTPlugin> pluginList = new ArrayList<>();

    //Actually more then one start transformer is overcomplicated
    //protected ArrayList<Transformer> startTransformer = new ArrayList<>();

    public XSLTPipeStart() {
        super();
        firstTransformation = true;
        selfContained = true;

    }

    public void setTransformerFactory(String transformerFactory) {
        this.transformerFactory = transformerFactory;
    }

    //public void setTemplate(String templatePath) {
    //
    //    this.templatePath = templatePath;
    //}

    public String getConfigFile() {
        return configFile;
    }

    public void setConfigFile(String configFile) {
        this.configFile = configFile;
    }

    public boolean isSelfContained() {
        return selfContained;
    }

    public void setSelfContained(boolean selfContained) {
        this.selfContained = selfContained;
    }

    @Override
    public void process(String obj) {

        if (firstTransformation) {
            firstTransformation = false;
            init();
            /*
            transformer = transformerFactory != null ?
                    new TemplateCreator(transformerFactory,
                            templatePath).createTransformerFromResource() :
                    new TemplateCreator( templatePath).createTransformerFromResource();
            */
        }

        //idea behind this logic:
        //there is a first transformation which is done before the startTemplate as first step in the
        //chain of xslt templates is executed
        //this first transformation is passed throug the whole pipeline and added in the last xslt transformation of the
        //data pipe. In our use case we need this to add the complete holdings into the SolrDoc
        TemplateTransformer tt = new TemplateTransformer(obj);

        XSLTDataObject dataObject = new XSLTDataObject();
        if (null != startTransformer) {
            //first: execute start transformation
            String resultStartTransformation = tt.transform(startTransformer);
            dataObject.additions.put(startTransformerKey, resultStartTransformation);
        }

        //set iowriter to empty string when new content is put into the pipe
        if (this.selfContained) oIOWriter.resetStream();

        dataObject.record = obj;
        getReceiver().process(dataObject);

    }

    protected void init() {

        readConfig();
        initPlugins();
        createStartTransformer();
        this.setReceiver(buildPipe());
    }

    protected void readConfig() {

        if (null != this.configFile) {
            ClassLoader classLoader = XSLTPipeStart.class.getClassLoader();
            try (InputStream is =  classLoader.getResourceAsStream(this.configFile)) {
                ObjectMapper mapper = new ObjectMapper(new YAMLFactory());
                this.pipeConfig = mapper.readValue(is, PipeConfig.class);
            } catch (IOException ioexc) {
                throw new MetafactureException(ioexc);
            }

        }
    }

    protected void initPlugins() {
        if (null != this.pipeConfig &&
                this.pipeConfig.getPlugins().containsKey("PLUGINS_TO_LOAD")) {
            this.pipeConfig.getPlugins().get("PLUGINS_TO_LOAD").forEach(
                    (keyNumber, pluginClass) -> {
                        //System.out.println(keyNumber + "," + pluginClass);
                        try {
                            Class tClass = Class.forName(pluginClass);
                            IXSLTPlugin docProcPlugin = (IXSLTPlugin)tClass.newInstance();
                            docProcPlugin.initPlugin(pipeConfig);
                            this.pluginList.add(docProcPlugin);

                        } catch (ClassNotFoundException |
                                InstantiationException |
                                IllegalAccessException createException) {
                            //todo handle exception
                            createException.printStackTrace();
                        }

                    }
            );
        }
    }

    protected void createStartTransformer() {
        if (null != this.pipeConfig &&
                this.pipeConfig.getXsltTemplates().containsKey("startTemplate")) {
            //just an assumption - actually I expect only one starter template
            //in case more templtes would be defined the latest is going to win..
          this.pipeConfig.getXsltTemplates().get("startTemplate").forEach(
                (templatekey, templatePath) -> {
                    startTransformer = transformerFactory != null ?
                            new TemplateCreator(transformerFactory,
                                    templatePath).createTransformerFromResource() :
                            new TemplateCreator( templatePath).createTransformerFromResource();
                    startTransformerKey = templatekey;

                    }

            );

        }
    }

    protected DefaultObjectPipe buildPipe () {

        DefaultObjectPipe op = null;

        if (null != this.pipeConfig) {
            if (this.pipeConfig.getXSLT_PIPE().size() == 1) {

                //only one template - we can use XSLTPipeStop
                this.pipeConfig.getXSLT_PIPE().forEach(
                        (indexKey, templateAttributes) -> {
                            XSLTPipeStop pipeStop = new XSLTPipeStop();
                            //todo I expect name attribute - checkit first!
                            pipeStop.setTemplate(templateAttributes.get("name"));
                        }
                );


            }  else if (this.pipeConfig.getXSLT_PIPE().size() > 1) {


                Optional<String> lastKey = this.pipeConfig.getXSLT_PIPE().keySet().stream().
                        reduce((first, second) -> Optional.of(second)
                                .orElse(null));

                Optional<String> firstKey = this.pipeConfig.getXSLT_PIPE().keySet().stream().
                        findFirst();

                ArrayList<Object> firstElement = new ArrayList<>();
                ArrayList<Object> stepList = new ArrayList<>();

                firstKey.ifPresent(fK -> lastKey.ifPresent(lK -> this.pipeConfig.getXSLT_PIPE().forEach(
                        (indexKey, templateAttributes) -> {
                            //System.out.println(templateAttributes);

                            if (!indexKey.equalsIgnoreCase(lK)) {
                                XSLTPipeStep pipeStep = new XSLTPipeStep();
                                pipeStep.setTemplate(templateAttributes.get("name"));
                                if (indexKey.equalsIgnoreCase(fK)) {
                                    firstElement.add(pipeStep);
                                } else {
                                    if (stepList.size() == 0) {
                                        ((DefaultObjectPipe) firstElement.get(0)).setReceiver(pipeStep);
                                    } else {
                                        ((DefaultObjectPipe) stepList.get(0)).setReceiver(pipeStep);
                                    }
                                    stepList.clear();
                                    stepList.add(pipeStep);
                                }
                            } else {
                                XSLTPipeStop pipeStop = new XSLTPipeStop();
                                pipeStop.setTemplate(templateAttributes.get("name"));

                                if (stepList.size() == 0) {
                                    ((DefaultObjectPipe) firstElement.get(0)).setReceiver(pipeStop);
                                } else {
                                    ((DefaultObjectPipe) stepList.get(0)).setReceiver(pipeStop);
                                }

                                //set ObjectWriter as last command for stopElement
                                ObjectJavaIoWriter iow = new ObjectJavaIoWriter<String>(new StringWriterFactory());
                                if (selfContained) {
                                    this.oIOWriter = iow;
                                }
                                pipeStop.setReceiver(iow);
                            }
                        }
                )));

                if (firstElement.size() == 1) {
                    op = (DefaultObjectPipe) firstElement.get(0);
                } else {
                    throw new MetafactureException("concept error of automatic xslt pipe creation");
                }

                /*
                Optional <Object> last =  stepList.stream().reduce((first, second) -> {
                    if (second instanceof XSLTPipeStep) {
                        return  ((XSLTPipeStep)first).setReceiver((XSLTPipeStep)second);
                    } else {
                        return  ((XSLTPipeStep)first).setReceiver((XSLTPipeStop)second);
                    }
                });
                */
            } else {
                throw new MetafactureException("XSLTPipes have to consist of at least two steps - Start / stop - no pipe was defined");
           }
        }

        return op;
    }

    public Optional<String> getTransformationResultOfPipe() {
        Optional<String> os;
        if (this.selfContained && null != this.oIOWriter) {
            os = Optional.of(this.oIOWriter.getCurrentStream());
        } else {
            os = Optional.empty();
        }
        return os;
    }

    @Override
    protected void onCloseStream() {
        this.pluginList.forEach(IXSLTPlugin::finalizePlugIn);
        super.onCloseStream();
    }
}
