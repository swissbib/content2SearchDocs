package org.swissbib.metafacture.xml.xslt.plugins;

import org.swissbib.metafacture.xml.xslt.helper.PipeConfig;


/**
 * Created by swissbib on 25.01.17.
 */
public class SolrStringTypePreprocessor implements IXSLTPlugin {



    public String getNavFieldForm(String rawToken) {

        return  "navFieldForm";

    }


    public String getNavFieldCombined(String rawToken) {
        return "navFieldCombined";

    }





    @Override
    public void initPlugin(PipeConfig configuration) {


    }

    @Override
    public void finalizePlugIn() {
    }



}
