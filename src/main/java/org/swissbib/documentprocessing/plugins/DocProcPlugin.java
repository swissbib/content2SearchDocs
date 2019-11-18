package org.swissbib.documentprocessing.plugins;

import org.swissbib.documentprocessing.flink.helper.PipeConfig;

public abstract class DocProcPlugin implements IDocProcPlugin {


    @Override
    public void initPlugin(PipeConfig configuration) {

    }

    @Override
    public abstract void finalizePlugIn();

    protected boolean checkProductive (PipeConfig configuration) {
        boolean productive = false;
        if (configuration.getPlugins().containsKey("PLUGINS_IN_PRODUCTIONMODE")) {
            productive = configuration.getPlugins().get("PLUGINS_IN_PRODUCTIONMODE").
                    containsValue(this.getClass().getName());
        }
        return productive;

    }
}
