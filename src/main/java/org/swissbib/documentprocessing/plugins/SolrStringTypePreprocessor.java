package org.swissbib.documentprocessing.plugins;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.tokenattributes.CharTermAttribute;
import org.swissbib.documentprocessing.solr.analyzer.NavFieldCombinedAnalyzer;
import org.swissbib.documentprocessing.solr.analyzer.NavFieldFormAnalyzer;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by swissbib on 25.01.17.
 */
public class SolrStringTypePreprocessor implements IDocProcPlugin {

    private static boolean inProductionMode = false;
    private static boolean initialized;
    private static TokenStream formAnalyzerTokenStream;

    private static HashMap<String,Analyzer> analyzerMap;
    private static HashMap<String,TokenStream> tokenStreams;


    static {
        analyzerMap = new HashMap<>();
        tokenStreams = new HashMap<>();
    }


    public String getNavFieldForm(String rawToken) {
         NavFieldFormAnalyzer formAnalyzer =  (NavFieldFormAnalyzer) SolrStringTypePreprocessor.analyzerMap.get("navFieldFormAnalyzer");

         //String testToken = "Quellenverzeichnis";
        //String testToken = "répertoire";
        //String testToken = "verzeichnis";

        TokenStream ts =  formAnalyzer.tokenStream("fieldNotNeeded",rawToken );

        ArrayList<String> list = new ArrayList<>(1);

        try {
            ts.reset();
            while (ts.incrementToken()) {
                final CharTermAttribute c= ts.getAttribute(CharTermAttribute.class);
                list.add(c.toString());
            }
            ts.close();
            //ts.end();
        } catch (IOException io){
            io.printStackTrace();
        }

        String retValue = "";
        if (list.size() == 1) {
            //todo: we need LogType
            System.out.println("Analyzer produces more than on term - should not happen");
            retValue = String.join("",list);
        }

        return retValue;


    }


    public String getNavFieldCombined(String rawToken) {
        Analyzer combinedAnalyzer =  SolrStringTypePreprocessor.analyzerMap.get("navFieldCombinedAnalyzer");

        //String testToken = "Quellenverzeichnis";
        //String testToken = "répertoire";
        //String testToken = "verzeichnis";

        TokenStream ts =  combinedAnalyzer.tokenStream("fieldNotNeeded",rawToken );


        String analyzedToken = "";
        try {
            ts.reset();

            while (ts.incrementToken()) {
                final CharTermAttribute c= ts.getAttribute(CharTermAttribute.class);
                analyzedToken = c.toString();
            }
            ts.close();
            //ts.end();
        } catch (IOException io){
            //todo: better handling
            io.printStackTrace();
        }


        return analyzedToken;


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
        if (SolrStringTypePreprocessor.analyzerMap != null) {

            if (SolrStringTypePreprocessor.analyzerMap.containsKey("navFieldFormAnalyzer")) {
                SolrStringTypePreprocessor.analyzerMap.get("navFieldFormAnalyzer").close();
            }
            if (SolrStringTypePreprocessor.analyzerMap.containsKey("navFieldCombinedAnalyzer")) {
                SolrStringTypePreprocessor.analyzerMap.get("navFieldCombinedAnalyzer").close();
            }

        }
    }



    private void initializeAalyser(HashMap<String, String> configuration) {

        String synonymDir = configuration.get("NAV_FIELD_FORM_SYNONYMS_DIR");
        NavFieldFormAnalyzer nfa =  new NavFieldFormAnalyzer(synonymDir);

        //nfa.getReuseStrategy()

        //SolrStringTypePreprocessor.tokenStreams.put("navFieldFormAnalyzer",nfa.tokenStream("test",""));
        //SolrStringTypePreprocessor.tokenStreams.get("navFieldFormAnalyzer").addAttribute(CharTermAttribute.class);



        SolrStringTypePreprocessor.analyzerMap.put("navFieldFormAnalyzer",nfa);

        NavFieldCombinedAnalyzer nfca = new NavFieldCombinedAnalyzer();
        SolrStringTypePreprocessor.analyzerMap.put("navFieldCombinedAnalyzer",nfca);



    }
}
