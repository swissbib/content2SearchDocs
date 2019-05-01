package org.swissbib.metafacture.xml.xslt.plugins;

import org.swissbib.metafacture.xml.xslt.helper.PipeConfig;

public class ExamplePlugin extends XSLTPlugin {

    @Override
    public void initPlugin(PipeConfig configuration) {
        boolean definedAsProductive = checkProductive(configuration);
        System.out.println("I'm initializing myself");
    }

    @Override
    public void finalizePlugIn() {
        System.out.println("I'm going to cleanup");
    }
}
