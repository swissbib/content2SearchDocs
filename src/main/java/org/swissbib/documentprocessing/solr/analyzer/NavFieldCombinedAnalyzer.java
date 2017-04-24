package org.swissbib.documentprocessing.solr.analyzer;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.core.KeywordTokenizer;
import org.apache.lucene.analysis.core.KeywordTokenizerFactory;
import org.apache.lucene.analysis.miscellaneous.LengthFilter;
import org.apache.lucene.analysis.miscellaneous.LengthFilterFactory;
import org.apache.lucene.analysis.miscellaneous.TrimFilterFactory;
import org.apache.lucene.analysis.pattern.PatternReplaceFilterFactory;

import java.util.HashMap;

/**
 * Created by swissbib on 25.01.17.
 */
public class NavFieldCombinedAnalyzer extends Analyzer {

    @Override
    protected TokenStreamComponents createComponents(String s) {
        HashMap<String,String> lF = new HashMap<>();
        lF.put("min","2");
        lF.put("max","100");

        LengthFilterFactory lff =  new LengthFilterFactory(lF);

        TrimFilterFactory tff =  new TrimFilterFactory(new HashMap<String,String>());

        HashMap<String,String> patternMap = new HashMap<>();
        //String pattern = "[S s]\\.[Nn]\\.|\\b[Aa]nonym\\b|\\b[Aa]nonym$|[\\[\\]*]|\\[.*\\]|" +
        //        "\\u0022|\\u003C|\\u003E|\\u003F|^\\d{4}-\\d{4}$|, \\d{4}-\\d{4}|" +
        //        "Formschlagwort|Aufsatzsammlung";
        String pattern = "[Ss]\\.[Nn]\\.|[\\[\\]*]|\\[.*\\]|" +
                "\\u0022|\\u003C|\\u003E|\\u003F|^\\d{4}-\\d{4}$|, \\d{4}-\\d{4}|" +
                "Formschlagwort|Aufsatzsammlung";


        patternMap.put("pattern", pattern);
        patternMap.put("replacement","");
        patternMap.put("replace","all");

        PatternReplaceFilterFactory prf =  new PatternReplaceFilterFactory(patternMap);

        KeywordTokenizerFactory kwtf =  new KeywordTokenizerFactory(new HashMap<>());

        KeywordTokenizer kwt = (KeywordTokenizer) kwtf.create();


        LengthFilter lengthFilter = lff.create(tff.create(prf.create(kwt)));

        return new TokenStreamComponents(kwt,lengthFilter);
    }


}
