package org.swissbib.solr.indexing.test;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;
import org.swissbib.documentprocessing.plugins.ViafContentEnrichment;

import java.util.HashMap;

/**
 * Created with IntelliJ IDEA.
 * User: swissbib
 * Date: 1/25/13
 * Time: 4:51 PM
 * To change this template use File | Settings | File Templates.
 */
public class VIAFEnrichmentTest {

    private HashMap<String, String> configuration;

    private ViafContentEnrichment viafFetch;

    @Before
    public void SetUp() {

        configuration = new HashMap<String, String>();

        configuration.put("VIAFINDEXBASE","http://sb-s1.swissbib.unibas.ch:8080/solr/viaf");
        configuration.put("SEARCHFIELD","matchstring");
        configuration.put("VALUESFIELD","personname");
        configuration.put("IDFIELD","id");

        System.setProperty("log4j.configuration","marcxml2solrlog4j.xml");

        viafFetch= new ViafContentEnrichment();
        viafFetch.initPlugin(configuration);



    }

    @Test
    public void initializeSolrServer() {

        assertTrue("solr server not initialized",viafFetch.solrServerInitialized());
        viafFetch.finalizePlugIn();
        assertFalse("solr server still initialized after Plugin was finalized",viafFetch.solrServerInitialized());


    }



    @Test
    public void runSimpleRequest() {

        viafFetch.searchVIAFPersonItem("hipler");

    }






}
