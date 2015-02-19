package org.swissbib.documentprocessing.plugins;

import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServer;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.BinaryRequestWriter;
import org.apache.solr.client.solrj.impl.BinaryResponseParser;
import org.apache.solr.client.solrj.impl.HttpSolrServer;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;




public class DeleteWeededDocuments implements  IDocProcPlugin{


    private static int maxNumbers;
    private static ArrayList<String> docIdsToDelete;
    private static SolrServer searchServerServerWeeding = null;
    private static boolean inProductionMode;
    private static String basePathWeedingDocuments;
    private static Logger logWeedingDocsToDelete;
    protected static  final String ls ;


    static {
        docIdsToDelete = new ArrayList<>();
        maxNumbers = 1000;
        inProductionMode = false;
        DeleteWeededDocuments.logWeedingDocsToDelete = LoggerFactory.getLogger(DeleteWeededDocuments.class);
        ls = System.getProperties().getProperty("line.separator");
    }


    @Override
    public void initPlugin(HashMap<String, String> configuration) {

        String className =  this.getClass().getName();
        if (configuration.containsKey("PLUGINS.IN.PRODUCTIONMODE") && configuration.get("PLUGINS.IN.PRODUCTIONMODE").contains(className) ) {
            inProductionMode = true;
            logWeedingDocsToDelete.info(DeleteWeededDocuments.class.getName() + " in ProductionMode and available");
        }
        else {
            logWeedingDocsToDelete.info(DeleteWeededDocuments.class.getName() + " not as productive configured -> can't be used");
            return;
        }


        try {
            initializePathForDocumentsToDelete(configuration);
            initializeSearchServerClient(configuration);

        } catch (Exception exep) {
            logWeedingDocsToDelete.error("Error in initializePathForDocumentsToDelete or initializeSearchServerClient");
            logWeedingDocsToDelete.error("component not in ProductionMode");
            logWeedingDocsToDelete.error("Exception", exep);

            inProductionMode = false;

        }

    }

    @Override
    public void finalizePlugIn() {

        writeDocuments();
        if (searchServerServerWeeding != null) {
            searchServerServerWeeding.shutdown();
        }
    }

    public void checkDocumentForDeletion (String docId) {


        if (inProductionMode) {


            SolrQuery parameters = new SolrQuery();
            parameters.set("rows",0);
            parameters.set("q", "id:" + docId);

            try {
                QueryResponse qResponse = searchServerServerWeeding.query(parameters);

                if (qResponse.getResults().getNumFound() > 1) {
                    logWeedingDocsToDelete.info(String.format("numbers of documents found with a unique id '%1$s': '%2$s' ",docId,
                            String.valueOf(qResponse.getResults().getNumFound())));
                    logWeedingDocsToDelete.info("all the documents on the server will be deleted - this state may indicate a severe error on the server ");

                }

                if (qResponse.getResults().getNumFound() > 0) {
                    logWeedingDocsToDelete.debug(String.format("weeded document with  id: '%1$s' is going to be deleted on the server", docId));

                    docIdsToDelete.add(docId);
                    if (docIdsToDelete.size() >= maxNumbers) {
                        writeDocuments();
                    }
                }

            } catch (SolrServerException solrException) {

                logWeedingDocsToDelete.error(String.format("error looking up document '%1$s' on Server ",docId), solrException );

            } catch (Throwable throwable) {

                logWeedingDocsToDelete.error(String.format("error looking up document '%1$s' on Server ",docId), throwable );

            }


        }

    }

    private BufferedWriter createFileForDocuments () throws IOException{

        Date dNow = new Date( );
        SimpleDateFormat ft =  new SimpleDateFormat ("yyyyMMdd_kmmss");
        String tFileName = basePathWeedingDocuments + File.separator + ft.format(dNow) + "_WeededDocumentsToDelete.xml";
        logWeedingDocsToDelete.info(String.format("new outfile '%1$s': for Ids going to be deleted on the index created", tFileName));

        return  new BufferedWriter(new OutputStreamWriter(new FileOutputStream( new File(tFileName)),"UTF-8"));
    }


    private void writeDocuments () {

        try {

            if (docIdsToDelete.size() > 0) {
                BufferedWriter bw = createFileForDocuments();
                bw.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
                bw.write(ls);
                bw.write(ls);
                bw.write("<delete>");
                bw.write(ls);
                bw.write(ls);
                bw.flush();
                for (String id : docIdsToDelete) {
                    bw.write("<id>" + id + "</id>");
                    bw.write(ls);
                }

                bw.write(ls);
                bw.write("</delete>");
                bw.flush();
                bw.close();

                logWeedingDocsToDelete.info(String.format("'%1$d': document IDs were written to outfile", docIdsToDelete.size()));
                //now delete all documents in the collection
                docIdsToDelete.clear();
                //to be sure: instantiate a new list
                docIdsToDelete = new ArrayList<String>();

            }

        } catch (IOException ioException) {
            logWeedingDocsToDelete.error("Error while trying to open a document for Ids from weeded documents which had to be deleted ", ioException);
        }



    }


    private void initializeSearchServerClient (HashMap<String, String> configuration) throws  Exception {

        String searchserver_weeding = configuration.get("SEARCHSERVER_WEEDING");

        HttpSolrServer searchServer =  new HttpSolrServer(searchserver_weeding);
        searchServer.setParser(new BinaryResponseParser());
        searchServer.setRequestWriter(new BinaryRequestWriter());
        searchServerServerWeeding = searchServer;

    }

    private void initializePathForDocumentsToDelete(HashMap <String, String> configuration) throws Exception{

        String basePath = configuration.get("PATH_WEEDING_DOCUMENTS_DELETE_ON_SERVER");

        File file = new File(basePath);
        if (! file.exists() || ! file.canWrite() ) {
            throw new Exception("base PATH_WEEDING_DOCUMENTS_DELETE_ON_SRVER doesn't exist or not writable");
        } else {
            basePathWeedingDocuments = basePath;
        }

    }
}
