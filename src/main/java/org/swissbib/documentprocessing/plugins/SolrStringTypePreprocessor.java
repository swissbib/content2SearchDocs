package org.swissbib.documentprocessing.plugins;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.tokenattributes.CharTermAttribute;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

    private static Logger navFieldForm;
    private static Logger navFieldCombined;
    private static Logger stringPreprocessorError;



    static {
        analyzerMap = new HashMap<>();
        tokenStreams = new HashMap<>();

        SolrStringTypePreprocessor.navFieldForm = LoggerFactory.getLogger("navFieldFormLogger");
        SolrStringTypePreprocessor.navFieldCombined = LoggerFactory.getLogger("navFieldCombinedLogger");
        SolrStringTypePreprocessor.stringPreprocessorError = LoggerFactory.getLogger("stringPreprocessorError");

    }


    public String getNavFieldForm(String rawToken) {


        String retValue = "";
        NavFieldFormAnalyzer formAnalyzer =  (NavFieldFormAnalyzer) SolrStringTypePreprocessor.analyzerMap.get("navFieldFormAnalyzer");
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
            stringPreprocessorError.error("error in getNavFieldForm");
            for (StackTraceElement se : io.getStackTrace()) {
                stringPreprocessorError.error(String.format("stacktraceelement: %s", se.toString()));
            }

        } catch (Throwable th) {
            for (StackTraceElement se : th.getStackTrace()) {
                stringPreprocessorError.error(String.format("stacktraceelement: %s", se.toString()));
            }
        }



        try {

            if (list.size() > 1) {
                //todo: we need LogType
                System.out.println("Analyzer produces more than one term - should not happen");
                retValue = String.join("",list);
            } else {
                retValue = list.size() == 1 ? list.get(0) : "";
            }
        } catch (Throwable th) {
            for (StackTraceElement se : th.getStackTrace()) {
                stringPreprocessorError.error(String.format("stacktraceelement: %s", se.toString()));
            }
        }


        navFieldForm.debug( String.format("navFieldForm: got \"%s\" returned \"%s\"", rawToken, retValue)  );
        return retValue;


    }


    public String getNavFieldCombined(String rawToken) {
        Analyzer combinedAnalyzer =  SolrStringTypePreprocessor.analyzerMap.get("navFieldCombinedAnalyzer");

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
            stringPreprocessorError.error("error in getNavFieldCombined");
            for (StackTraceElement se : io.getStackTrace()) {
                stringPreprocessorError.error(String.format("stacktraceelement: %s", se.toString()));
            }
        } catch (Throwable th) {
            for (StackTraceElement se : th.getStackTrace()) {
                stringPreprocessorError.error(String.format("stacktraceelement: %s", se.toString()));
            }
        }


        navFieldCombined.debug( String.format("navFieldCombined: got \"%s\" returned \"%s\"", rawToken, analyzedToken)  );
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
