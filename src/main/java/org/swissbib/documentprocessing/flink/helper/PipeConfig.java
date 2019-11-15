package org.swissbib.documentprocessing.flink.helper;

import java.io.Serializable;
import java.util.Map;

public class PipeConfig implements Serializable {

    public Map<String, String> kafka;

    public Map<String, String> simpleValues;

    public Map<String,String> fileBasedConfig;

    public Map<String, Map<String,String>> xsltTemplates;

    public  Map<String, Map<String,String>> plugins;

    public Map<String, Map<String,String>> XSLT_PIPE;


    public Map<String, Map<String, String>> getXsltTemplates() {
        return xsltTemplates;
    }

    public void setXsltTemplates(Map<String, Map<String, String>> xsltTemplates) {
        this.xsltTemplates = xsltTemplates;
    }

    public Map<String, Map<String, String>> getPlugins() {
        return plugins;
    }

    public void setPlugins(Map<String, Map<String, String>> plugins) {
        this.plugins = plugins;
    }

    public Map<String, String> getSimpleValues() {
        return simpleValues;
    }

    public void setSimpleValues(Map<String, String> simpleValues) {
        this.simpleValues = simpleValues;
    }

    public Map<String, String> getFileBasedConfig() {
        return fileBasedConfig;
    }

    public void setFileBasedConfig(Map<String, String> fileBasedConfig) {
        this.fileBasedConfig = fileBasedConfig;
    }

    public Map<String, Map<String, String>> getXSLT_PIPE() {
        return XSLT_PIPE;
    }

    public void setXSLT_PIPE(Map<String, Map<String, String>> XSLT_PIPE) {
        this.XSLT_PIPE = XSLT_PIPE;
    }

    public Map<String, String> getKafka() {
        return kafka;
    }

    public void setKafka(Map<String, String> kafka) {
        this.kafka = kafka;
    }
}
