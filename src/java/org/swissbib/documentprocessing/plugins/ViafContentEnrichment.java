package org.swissbib.documentprocessing.plugins;

import org.apache.solr.client.solrj.*;
import org.apache.solr.client.solrj.impl.HttpSolrServer;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;
import org.apache.solr.common.params.ModifiableSolrParams;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;

/**
 * [...description of the type ...]
 * <p/>
 * <p/>
 * <p/>
 * Copyright (C) project swissbib, University Library Basel, Switzerland
 * http://www.swissbib.org  / http://www.swissbib.ch / http://www.ub.unibas.ch
 * <p/>
 * Date: 8/2/13
 * Time: 7:18 AM
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2,
 * as published by the Free Software Foundation.
 * <p/>
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * <p/>
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * <p/>
 * license:  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 *
 * @author Guenter Hipler  <guenter.hipler@unibas.ch>
 * @link http://www.swissbib.org
 * @link https://github.com/swissbib/xml2SearchDoc
 */



public class ViafContentEnrichment implements IDocProcPlugin {

    private static Logger viafProcessing;
    private static Logger viafProcessingError;

    private static HttpSolrServer solrServer;

    private static String searchField;
    private static String valuesField;
    private static String viafIDField;


    static {

        viafProcessing = LoggerFactory.getLogger(ViafContentEnrichment.class);
        viafProcessingError = LoggerFactory.getLogger("viafProcessingError");

    }


    @Override
    public void initPlugin(HashMap<String, String> configuration) {

        viafProcessing.info("\n\n start to initialize the VIAF Content Enrichment Plugin\n");

        initializeIndexAccess(configuration);

        searchField = configuration.get("SEARCHFIELD");
        valuesField = configuration.get("VALUESFIELD");
        viafIDField = configuration.get("IDFIELD");
        viafProcessing.info("initialization of VIAF Content Enrichment Plugin has finished \n\n");

    }


    public String searchVIAFPersonItem(String swissbibPerson) {


        String viafItem = null;
        StringBuilder sBuilder = new StringBuilder();

        //expected return value if successful
        //id###viafPerson###[viafPerson] -n

        HashMap<String,String[]> viafQuery = new HashMap<String, String[]>();
        //viafQuery.put("q",searchField + ":" + swissbibPerson);

        //todo: transform swissbibPerson tp matchstring

        viafQuery.put("q",new String [] {searchField + ":" + swissbibPerson});
        viafQuery.put("qt", new String [] {"/search"});
        //viafQuery.put("wt", new String [] {"javabin"});
        //viafQuery.put("version", new String [] {"2"});

        ModifiableSolrParams mp = new ModifiableSolrParams(viafQuery);


        SolrQuery sq = new SolrQuery();
        sq.add(mp);

        //QueryRequest qR = new QueryRequest(mp);


        try {
            //solrServer.request(qR) ;

            QueryResponse qR = solrServer.query(sq);

            if (qR.getResults().getNumFound() > 0) {

                SolrDocumentList dL = qR.getResults();

                Iterator <SolrDocument>  docList = dL.iterator();

                while (docList.hasNext()) {
                    SolrDocument doc = docList.next();

                    sBuilder.append(doc.getFieldValue(viafIDField)).append("###");

                    Collection<Object> personNames =  doc.getFieldValues(valuesField);

                    for (Object name : personNames) {

                        sBuilder.append((String) name).append("###");

                    }
                }

            }


        }  catch (SolrServerException solrServerExc) {
            solrServerExc.printStackTrace();
        }




        return viafItem;

    }


    @Override
    public void finalizePlugIn() {
        ViafContentEnrichment.solrServer = null;
    }


    private void initializeIndexAccess(HashMap<String, String> configuration) {


        viafProcessing.info("initializing index access ");

        viafProcessing.info("index URL: " + configuration.get("VIAFINDEXBASE"));


            String test = configuration.get("VIAFINDEXBASE");

            ViafContentEnrichment.solrServer = new HttpSolrServer(configuration.get("VIAFINDEXBASE"));

            /*
            marcXMLlogger.info("\n\n => Start to load the properties of configuration File: " + confContainer.getCONFFILE());

            String serverURL = configProps.getProperty("SOLR.REMOTE.CONTENT.URL");
            marcXMLlogger.info("\n => Loading SOLR.REMOTE.CONTENT.URL:" + serverURL);

            if (null != serverURL && serverURL.length() > 0) {

                CommonsHttpSolrServer tsServer = null;

                try {
                    tsServer = new CommonsHttpSolrServer( serverURL );
                    tsServer.setSoTimeout(60000);  // socket read timeout
                    tsServer.setConnectionTimeout(100);
                    tsServer.setDefaultMaxConnectionsPerHost(100);
                    tsServer.setMaxTotalConnections(100);
                    tsServer.setFollowRedirects(false);  // defaults to false
                    // allowCompression defaults to false.
                    // Server side must support gzip or deflate for this to have any effect.
                    tsServer.setAllowCompression(true);
                    tsServer.setMaxRetries(1); // defaults to 0.  > 1 not recommended.
                    marcXMLlogger.info("\n => ContentServer for remote content [fetched via FAST] initialized");

                } catch(MalformedURLException malFormedEx) {
                    malFormedEx.printStackTrace();
                    tsServer = null;
                } catch (Exception ex) {
                    ex.printStackTrace();
                    tsServer = null;
                } finally {
                    confContainer.setSolrServer(tsServer);


                }

            }

         */
    }



    public boolean solrServerInitialized () {

        return null != ViafContentEnrichment.solrServer;
    }

}
