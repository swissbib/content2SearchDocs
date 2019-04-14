package org.swissbib.solr.indexing.test;

import org.junit.Before;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Disabled;
import org.swissbib.documentprocessing.plugins.GNDContentEnrichment;

import java.util.HashMap;

import static org.junit.Assert.*;

/**
 * Created with IntelliJ IDEA.
 * User: swissbib
 * Date: 12/20/12
 * Time: 7:36 PM
 * To change this template use File | Settings | File Templates.
 */
public class GNDEnrichmentTest {

    private HashMap<String, String> configuration;



   @Before
   public void SetUp() {

       configuration = new HashMap<String, String>();
       configuration.put("SOURCE.TO.FETCH.GND","https://portal.dnb.de/opac.htm?method=requestMarcXml&idn={0}");
       configuration.put("ID.PATTERN.TO.REPLACE","?##?");
       configuration.put("PATTERN.FOR.ID","^(\\(.*?\\))(.*)$");
       configuration.put("TAGS.TO.USE","400_a###400_b###400_c###400_d###400_x###410_a###410_b###411_a###411_b###430_a###450_a###450_x###451_a###451_x");
       configuration.put("PROXYSERVER","proxy.unibas.ch:3128");
       configuration.put("MONGO.CLIENT","localhost###29017");
       configuration.put("MONGO.AUTHENTICATION","admin###admi###ayKejO3");
       configuration.put("MONGO.DB","nativeSources###sourceDNBGND###gndid###gndfields");

       System.setProperty("log4j.configuration","marcxml2solrlog4j.xml");



   }

    @Disabled("actually not running - again after MF integration")
    @Test
    public void fetchGNDID () {


        GNDContentEnrichment gnd = new GNDContentEnrichment();
        gnd.initPlugin(configuration);


        String oneGNDcat = gnd.getReferencesConcatenated("(DE-588)15995-5");
        String zeroGNDcat = gnd.getReferencesConcatenated("(DE-588)16008-8");
        //

        gnd.finalizePlugIn();


        //System.out.println(oneGNDcat);
        //assertTrue("should be only one element 'Kommunikationskontrolle'", oneGNDcat.split("##xx##").length == 1) ;

        //String sevengndCat = gnd.getReferencesConcatenated("(DE-588)4035964-5");
        //System.out.println(sevengndCat);
        //assertTrue("should have 7 elements",sevengndCat.split("##xx##").length == 7);


    }

    @Disabled("actually not running - again after MF integration")
    @Test
    public void fetchGNDIDasXML () {


        GNDContentEnrichment gnd = new GNDContentEnrichment();
        gnd.initPlugin(configuration);

        String first =  gnd.getReferencesAsXML("(DE-588)4067601-8");
        System.out.println(first);
        assertTrue(first.length() > 0);

        String second = gnd.getReferencesAsXML("(DE-588)4035964-5");
        System.out.println(second);
        assertTrue(second.length() > 0);





    }




}
