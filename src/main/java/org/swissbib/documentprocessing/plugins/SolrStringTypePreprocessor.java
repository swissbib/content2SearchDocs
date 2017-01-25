package org.swissbib.documentprocessing.plugins;

import org.apache.lucene.analysis.Analyzer;
import org.swissbib.documentprocessing.solr.analyzer.NavFieldCombinedAnalyzer;
import org.swissbib.documentprocessing.solr.analyzer.NavFieldFormAnalyzer;

import java.util.HashMap;

/**
 * Created by swissbib on 25.01.17.
 */
public class SolrStringTypePreprocessor implements IDocProcPlugin {

    private static boolean inProductionMode = false;
    private static boolean initialized;

    private static HashMap<String,Analyzer> analyzerMap;

    static {
        analyzerMap = new HashMap<>();
    }


    @Override
    public void initPlugin(HashMap<String, String> configuration) {


        String className =  this.getClass().getName();
        if (configuration.containsKey("PLUGINS.IN.PRODUCTIONMODE") && configuration.get("PLUGINS.IN.PRODUCTIONMODE").contains(className) )
            inProductionMode = true;
        else
            return;

        initializeAalyser(configuration);



    }

    @Override
    public void finalizePlugIn() {
        //Todo: Do something to close the analysers
    }



    private void initializeAalyser(HashMap<String, String> configuration) {

        String synonymDir = configuration.get("NAV_FIELD_FORM_SYNONYMS_DIR");
        NavFieldFormAnalyzer nfa =  new NavFieldFormAnalyzer(synonymDir);


        SolrStringTypePreprocessor.analyzerMap.put("navFieldFormAnalyzer",nfa);

        NavFieldCombinedAnalyzer nfca = new NavFieldCombinedAnalyzer();
        SolrStringTypePreprocessor.analyzerMap.put("navFieldCombinedAnalyzer",nfca);



    }
}
