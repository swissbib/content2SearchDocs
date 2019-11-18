package org.swissbib.documentprocessing.flink.functions;

import org.apache.flink.api.common.functions.RichMapFunction;
import org.apache.flink.configuration.Configuration;
import org.swissbib.documentprocessing.flink.helper.PipeConfig;
import org.swissbib.documentprocessing.flink.helper.TemplateCreator;
import org.swissbib.documentprocessing.flink.helper.TemplateTransformer;
import org.swissbib.documentprocessing.flink.helper.XSLTDataObject;
import org.swissbib.documentprocessing.plugins.IDocProcPlugin;

import javax.xml.transform.Transformer;
import java.util.ArrayList;

public class MapDataObject2DataObjectFunction extends RichMapFunction<XSLTDataObject, XSLTDataObject> {

    private PipeConfig pipeConfig;
    private String templateName;
    private Transformer transformer;

    //todo: GH: static or not static - don't know actually..
    private ArrayList<IDocProcPlugin> pluginList = new ArrayList<>();

    private boolean loadXSLTPlugins = false;

    private boolean holdings = false;


    public MapDataObject2DataObjectFunction(PipeConfig pipeConfig,
                                            String templateName) {
        this (pipeConfig, templateName, false);


    }

    public MapDataObject2DataObjectFunction(PipeConfig pipeConfig,
                                            String templateName,
                                            boolean loadPlugins) {
        this.pipeConfig = pipeConfig;
        this.templateName = templateName;
        this.loadXSLTPlugins = loadPlugins;

    }


    public MapDataObject2DataObjectFunction(PipeConfig pipeConfig,
                                            String templateName,
                                            boolean loadPlugins,
                                            boolean holdings) {

        this(pipeConfig, templateName, loadPlugins);
        this.holdings = holdings;

    }


    @Override
    public XSLTDataObject map(XSLTDataObject value) throws Exception {

        String test = value.record;

        if (holdings && value.additions.containsKey("holdingsStructure")) {
            transformer.setParameter("holdingsStructure",value.additions.get("holdingsStructure"));
        }
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
        loadPlugins();
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

    protected void loadPlugins() {
        if (this.loadXSLTPlugins) {

            if (this.pipeConfig.getPlugins().containsKey("PLUGINS_TO_LOAD")) {
                this.pipeConfig.getPlugins().get("PLUGINS_TO_LOAD").forEach(
                        (keyNumber, pluginClass) -> {
                            //System.out.println(keyNumber + "," + pluginClass);
                            try {
                                Class tClass = Class.forName(pluginClass);
                                IDocProcPlugin docProcPlugin = (IDocProcPlugin)tClass.newInstance();
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
    }



}
