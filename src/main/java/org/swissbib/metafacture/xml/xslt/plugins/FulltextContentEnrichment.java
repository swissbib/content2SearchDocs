package org.swissbib.metafacture.xml.xslt.plugins;

import org.swissbib.metafacture.xml.xslt.helper.PipeConfig;


public class FulltextContentEnrichment implements IXSLTPlugin{


    private static  String ls = System.getProperties().getProperty("line.separator");
    //private static ConfigContainer configContainer = null;




    public String readURLContent(String url, String DocId) {

        return "hier doc content";


    }

    @Override
    public void initPlugin(PipeConfig configuration) {

    }

    @Override
    public void finalizePlugIn() {

    }
}
