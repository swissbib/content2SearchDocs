package org.swissbib.documentprocessing.solr.analyzer;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.core.KeywordTokenizer;
import org.apache.lucene.analysis.core.KeywordTokenizerFactory;
import org.apache.lucene.analysis.miscellaneous.LengthFilter;
import org.apache.lucene.analysis.miscellaneous.LengthFilterFactory;
import org.apache.lucene.analysis.miscellaneous.TrimFilterFactory;
import org.apache.lucene.analysis.pattern.PatternReplaceFilterFactory;
import org.apache.lucene.analysis.synonym.SynonymFilterFactory;
import org.apache.lucene.analysis.util.ClasspathResourceLoader;
import org.apache.lucene.analysis.util.ResourceLoader;

import java.io.IOException;
import java.util.HashMap;

/**
 * Created by swissbib on 25.01.17.
 */
public class NavFieldFormAnalyzer extends Analyzer {

    private String synonymFile = "";

    public NavFieldFormAnalyzer(String synonymFile) {
        this.synonymFile = synonymFile;
    }



    @Override
    protected TokenStreamComponents createComponents(String s) {
        HashMap<String,String> lF = new HashMap<>();
        lF.put("min","2");
        lF.put("max","60");

        LengthFilterFactory lff =  new LengthFilterFactory(lF);


        HashMap<String,String> sFM = new HashMap<>();
        sFM.put("synonyms",this.synonymFile);
        sFM.put("ignoreCase","true");
        sFM.put("expand","false");
        sFM.put("tokenizerFactory",KeywordTokenizerFactory.class.getTypeName());

        //Todo: configuration for the directory
        //Path path = FileSystems.getDefault().getPath(this.synonymDir);
        ResourceLoader rl = new ClasspathResourceLoader(this.getClass().getClassLoader());

        SynonymFilterFactory sff = new SynonymFilterFactory(sFM);

        try {
            sff.inform(rl);
        } catch (IOException ioE) {
            ioE.printStackTrace();
        }


        TrimFilterFactory tff =  new TrimFilterFactory(new HashMap<String,String>());

        HashMap<String,String> patternMap = new HashMap<>();
        String pattern = "\\u003C|\\u003E|\\[|\\]|\\u0028|\\u0029|Formschlagwort|Sondersammlungen";

        patternMap.put("pattern", pattern);
        patternMap.put("replacement","");

        PatternReplaceFilterFactory prf4 =  new PatternReplaceFilterFactory(patternMap);

        pattern = "^Ausstellung \\(.*\\)";
        patternMap.put("replacement","Ausstellung");
        patternMap.put("pattern",pattern);
        PatternReplaceFilterFactory prf3 =  new PatternReplaceFilterFactory(patternMap);


        pattern = "^Kongress \\(.*\\)";
        patternMap.put("replacement","Kongressbericht");
        patternMap.put("pattern",pattern);
        PatternReplaceFilterFactory prf2 =  new PatternReplaceFilterFactory(patternMap);


        pattern = "^[0A] Gesamtdarstell.*$";
        patternMap.put("replacement","Gesamtdarstellung");
        patternMap.put("pattern",pattern);
        PatternReplaceFilterFactory prf1 =  new PatternReplaceFilterFactory(patternMap);



        KeywordTokenizerFactory kwtf =  new KeywordTokenizerFactory(new HashMap<String,String>());

        KeywordTokenizer kwt = (KeywordTokenizer) kwtf.create();

        LengthFilter lengthFilter = lff.create(sff.create(tff.create(prf4.create(prf3.create(prf2.create(prf1.create(kwt)))))));


        return new TokenStreamComponents(kwt,lengthFilter);
    }
}
