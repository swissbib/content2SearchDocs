package org.swissbib.metafacture.xml.xslt.plugins;

import org.swissbib.metafacture.xml.xslt.helper.PipeConfig;

public abstract class XSLTPlugin implements IXSLTPlugin {

    @Override
    public abstract void initPlugin(PipeConfig configuration);

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
