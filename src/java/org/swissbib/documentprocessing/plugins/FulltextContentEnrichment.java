package org.swissbib.documentprocessing.plugins;

import org.apache.tika.Tika;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.net.*;
import java.sql.*;
import java.util.*;
import java.util.regex.Pattern;


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



public class FulltextContentEnrichment implements IDocProcPlugin{


    private static  String ls = System.getProperties().getProperty("line.separator");
    //private static ConfigContainer configContainer = null;



    private static Logger tikaexceptionLogger;
    private static Logger tikaContentLogger;
    private static Logger tikaNoContentLogger;
    private static Logger tikaContentProcessing;

    private static Connection dbmsConnection = null;
    private static ArrayList<Pattern> patternsAllowed;
    private static ArrayList<Pattern> patternsNotAllowed;

    private static Integer maxLength;
    private static Tika tika;
    private static Proxy proxy;
    private static String testPDF;
    private static ArrayList<String> allowedContentType;
    private static boolean execRemoteFetching;
    private static boolean  initialized;
    private static Pattern separator;
    private static HashMap<String, PreparedStatement> prepStats = new HashMap<String, PreparedStatement>();


    static {

        FulltextContentEnrichment.tikaContentLogger = LoggerFactory.getLogger("tikaContent");
        FulltextContentEnrichment.tikaNoContentLogger = LoggerFactory.getLogger("tikaContentNoMatch");
        FulltextContentEnrichment.tikaexceptionLogger = LoggerFactory.getLogger("tikaException");
        FulltextContentEnrichment.tikaContentProcessing = LoggerFactory.getLogger("contentProcessing");

        patternsAllowed = new ArrayList<Pattern>();
        patternsNotAllowed = new ArrayList<Pattern>();

        maxLength = 10000;
        allowedContentType = new ArrayList<String>();
        execRemoteFetching = true;
        initialized = false;
        separator = Pattern.compile(("^\\||\\|$"));

    }


    //Beispiel, in FAST indexiert
    //http://opac.nebis.ch/objects/pdf/e01_978-3-642-10664-4_01.pdf

    public String readURLContent(String url, String DocId) {

        String content = "";

            //if we couldn't fetch content from the server we (content length == 0) use Tika - if activated
            if (execRemoteFetching){
                boolean matched = false;
                for (Pattern p : patternsAllowed ) {
                    if (p.matcher(url).find())
                    {

                        matched = true;

                        //if there was no solr content server available - try to get the content from DBMS
                        if (this.dbmsConnectionActive()) {
                            content = fetchContentDBMS(DocId,url);

                            if (content.length() > 0) {


                                tikaContentLogger.debug("got content from DBMS for DocId: " + DocId + " / url: " + url);
                                break;

                            }
                        }

                        if (content.length() == 0) {

                            //why this separator....??? What was the problem?
                            //Matcher m =  separator.matcher(url);
                            //String urlClean = m.replaceAll("");
                            try {


                                boolean httpFetchingAllowed = true;

                                for (Pattern p1 : patternsNotAllowed ){
                                    if (p1.matcher(url).find()) {

                                        tikaContentLogger.debug("URL: xxxx" + url + "xxxx not allowed for fetching Docid: ####" + DocId + "####");
                                        httpFetchingAllowed = false;

                                    }
                                }

                                if (!httpFetchingAllowed) continue;


                                HttpURLConnection connection = getHTTPConnection(url);

                                boolean fetch = true;
                                if (isContentTypeRestricted()) {
                                    fetch = false;
                                    String type = connection.getContentType();
                                    for (String tType: allowedContentType) {
                                        if (type.equals(tType)) {
                                            fetch = true;
                                            break;
                                        }
                                    }

                                    if (!fetch && null != tikaContentLogger){

                                        tikaContentLogger.debug("content type not allowed: " + type);

                                    }
                                }

                                if (fetch) {


                                    //todo: testen wie sich das Fetchen mit Schliessen des InputStreams verhält - s.u.
                                    //Problem ETH???
                                    InputStream contentStream = (InputStream) connection.getContent();

                                    content = tika.parseToString((contentStream));

                                    if (null != tikaContentLogger) {


                                        tikaContentLogger.debug("Docid fetched: " + DocId);
                                        tikaContentLogger.debug("url fetched: " + url);
                                        tikaContentLogger.debug("content: \n" + content);
                                    }

                                    if (null != dbmsConnection) {

                                        insertContentDBMS(DocId,url,content);

                                    }

                                    if (null !=  contentStream) {
                                        contentStream.close();
                                    }
                                }

                                break;

                            }catch (Throwable th) {
                                tikaexceptionLogger.error("Error while trying to fetch the remote doc with Tika");
                                tikaexceptionLogger.error(th.getMessage());
                                for (StackTraceElement sE: th.getStackTrace()) {
                                    tikaexceptionLogger.error(sE.toString());
                                }
                                tikaexceptionLogger.error("DocID which caused exception: " + DocId);
                                tikaexceptionLogger.error("URL which caused exception: " + url);

                            }
                        }

                    }
                }
                if (!matched) {
                    tikaNoContentLogger.debug("no match Docid: " + DocId);
                    tikaNoContentLogger.debug("no match URL: " + url + "\n");
                }

            }

        return content.replaceAll("\n"," ");


    }


    /***
     *This method was made public because it is useful to fetch documents in advance from the database
     *in the "drop-usecase" related to Nebis
     * In "drop-usecase" - mode we are going to fetch all documents when the document processing is already finished
     * in batch mode. Because I want only documents which are really not in db I want to make a "pre-check"
     * This method is useful for this
     */
    public String fetchContentDBMS (String docid, String url) {


        String remoteContent = "";

        PreparedStatement statement = prepStats.get("select");

        try {

            statement.setString(1,docid);
            statement.setString(2,url);

            ResultSet rs = statement.executeQuery();



            while (rs.next()) {
                remoteContent = rs.getString("content");
            }


        } catch (SQLException sqlExc) {
            sqlExc.printStackTrace();
        }



        return remoteContent;

    }

    private void insertContentDBMS (String docid, String url, String content) {

        PreparedStatement statement = prepStats.get("insert");


        java.util.Date today = new java.util.Date();
        java.sql.Date date =  new java.sql.Date(today.getTime());

        try {

            statement.setString(1,docid);
            statement.setString(2,content);
            statement.setString(3,url);
            statement.setDate(4,date);


            statement.executeUpdate();

        } catch (SQLException sqlExc) {
            sqlExc.printStackTrace();
        }




    }



    //public static void init (ConfigContainer configContainer) {

        //FulltextContentEnrichment.configContainer = configContainer;

    //    FulltextContentEnrichment.tikaContentLogger = LoggerFactory.getLogger("tikaContent");
    //    FulltextContentEnrichment.tikaNoContentLogger = LoggerFactory.getLogger("tikaContentNoMatch");
    //    FulltextContentEnrichment.tikaexceptionLogger = LoggerFactory.getLogger("tikaException");

    //}






    private HttpURLConnection getHTTPConnection (String url) throws
            MalformedURLException, IOException

    {
        HttpURLConnection uc = null;

        if(testPDF != null) {
            //is this possible (only file path???
            URL u =new URL(testPDF);
            uc = (HttpURLConnection)u.openConnection();
            uc.connect();


        } else {
            URL u = new URL(url);
            if (proxy != null) {
                uc = (HttpURLConnection)u.openConnection(proxy);
                uc.connect();

            } else {

                uc = (HttpURLConnection)u.openConnection();
                uc.connect();
            }
        }



        return uc;

    }

    public boolean isContentTypeRestricted() {
        return null != allowedContentType && allowedContentType.size() > 0;
    }


    @Override
    public void initPlugin(HashMap<String, String> configuration) {


        initializeDBMS(configuration);
        initializeallowedDocuments(configuration);
        initializeNotallowedDocuments(configuration);
        initializeDocumentMaxLength(configuration);
        initializeTika(configuration);
        initializeProxy(configuration);
        initializeTestPDF(configuration);
        initializeAllowedContentType(configuration);
        initializeActivateRemoteFetching(configuration);

        initialized = true;

        //To change body of implemented methods use File | Settings | File Templates.



    }

    @Override
    public void finalizePlugIn() {

        if (null != dbmsConnection) {
            try {
                dbmsConnection.close();
            } catch (SQLException sqlExc) {
                tikaContentLogger.error("error while closing the DBMSconnection");
            }
        }
        //To change body of implemented methods use File | Settings | File Templates.
    }


    private void initializeDBMS(HashMap<String, String> configuration) {

        String driver = configuration.get("JDBCDRIVER");
        String jdbcConnection = configuration.get("JDBCCONNECTION");
        String user = configuration.get("user".toUpperCase());
        String password = configuration.get("passwd".toUpperCase());


        if (null != driver && driver.length() > 0) {

            try {
                //System.out.println(configsDBMS.getProperty("JDBCdriver"));
                Class.forName(driver).newInstance();
                tikaContentProcessing.info("appropriate driver: " + driver + " was loaded ");
                Connection conn = null;

                conn = DriverManager.getConnection(jdbcConnection, user, password);

                dbmsConnection = conn;
                prepareStatement(dbmsConnection);


            } catch (ClassNotFoundException cnfe) {
                tikaContentProcessing.error("error while class not found - no use of DBMS for cached content ",cnfe);

            } catch (InstantiationException ie) {
                tikaContentProcessing.error("error while instantiating database connection - no use of DBMS for cached content",ie);

            } catch (IllegalAccessException iae) {

                tikaContentProcessing.error("error illegalAccess - no use of DBMS for cached content",iae );

            } catch (SQLException sqlEx) {

                sqlEx.printStackTrace();
                tikaContentProcessing.error("sqlException - no use of DBMS for cached content",sqlEx );

            }

        }
    }


    private static void prepareStatement (Connection dbConnection) {
        prepStats = new HashMap<String, PreparedStatement>();

        PreparedStatement tempPrepared = null;
        StringBuilder errorMessage;

        try {
            tempPrepared = dbConnection.prepareStatement( "select * from content " +
                    " where docid = ? and url = ? " );
            prepStats.put("select", tempPrepared);


            tempPrepared = dbConnection.prepareStatement( "insert into content " +
                    " (docid, content, url, date) values (?,?,?,?)" );
            prepStats.put("insert", tempPrepared);


        } catch (SQLException sqlExc) {

            sqlExc.printStackTrace();
        }


    }


    private void initializeallowedDocuments(HashMap<String, String> configuration) {

        String allowedDocs = configuration.get("ALLOWED.DOCUMENTS");
        tikaContentProcessing.info("\n => Loading ALLOWED.DOCUMENTS: " + allowedDocs);


        if (allowedDocs != null && allowedDocs.length() > 0) {
            ArrayList<String> regexs;
            regexs = new ArrayList<String>();
            regexs.addAll(Arrays.asList(allowedDocs.split("###")));

            //ArrayList<Pattern> patterns = new ArrayList<Pattern>();

            for (String regex : regexs ) {
                patternsAllowed.add(Pattern.compile(regex));
            }
            //confContainer.setDocumentPatterns(patterns);
        }
    }



    private void initializeTestPDF(HashMap<String, String> configuration) {

        String tP = configuration.get("TEST.PDF");
        tikaContentProcessing.info("\n => Loading TEST.PDF: " + tP);

        if (tP != null && tP.length()>0) {
            testPDF = tP;
        }
    }


    private void initializeAllowedContentType(HashMap<String, String> configuration) {

        String propallowedContentType = configuration.get("ALLOWEDCONTENTTYPE");
        tikaContentProcessing.info("\n => Loading ALLOWEDCONTENTTYPE: " + propallowedContentType);

        if (propallowedContentType != null && propallowedContentType.length()>0) {

            allowedContentType.addAll(Arrays.asList(propallowedContentType.split("###")));

        }
    }


    private void initializeActivateRemoteFetching(HashMap<String, String> configuration) {

        String sExec = configuration.get("REMOTEFETCHING");
        tikaContentProcessing.info("\n => Loading REMOTEFETCHING: " + sExec);
        execRemoteFetching = Boolean.valueOf(sExec);
    }



    private void initializeProxy(HashMap<String, String> configuration) {

        String proxyProp = configuration.get("PROXYSERVER");

        if (proxyProp != null && proxyProp.length()>0) {
            try {

                String proxyServer = null;
                Integer proxyPort = 0;

                if (proxyProp.contains(":")) {


                    String [] serverParts = proxyProp.split(":");
                    proxyServer = serverParts[0];
                    proxyPort = Integer.valueOf(serverParts[1]);

                    proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress(proxyServer, proxyPort));
                }
                else {
                    proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress(proxyServer, 80));
                }

                tikaContentProcessing.info("proxy - object: " + proxyProp + " initialized");

            }catch (Throwable th) {

                tikaContentProcessing.error("\n => Error while creating Proxy");
                tikaContentProcessing.error(th.getMessage());
                proxy = null;

            }

        }
    }



    private void initializeDocumentMaxLength(HashMap<String, String> configuration) {


        try {

            maxLength = new Integer(configuration.get("MAXLENGTH.FETCHED.DOCUMENTS"));

        } catch (Throwable th) {

            maxLength = 10000;
            tikaContentProcessing.error("\n => Error while Loading MAXLENGTH.FETCHED.DOCUMENTS");
            tikaContentProcessing.error(th.getMessage());

        } finally {

            tikaContentProcessing.info("Max length of documents is set to: " +  maxLength);

        }
    }


    private void initializeTika(HashMap<String, String> configuration) {

        tika = new Tika();
        tika.setMaxStringLength(maxLength);


    }


    private void initializeNotallowedDocuments(HashMap<String, String> configuration) {

        String notAllowedDocs = configuration.get("HTTP.FETCH.NOT.ALLOWED");
        tikaContentProcessing.info("\n => Loading ALLOWED.DOCUMENTS: " + notAllowedDocs);


        if (notAllowedDocs != null && notAllowedDocs.length() > 0) {
            ArrayList<String> regexs;
            regexs = new ArrayList<String>();
            regexs.addAll(Arrays.asList(notAllowedDocs.split("###")));

            //ArrayList<Pattern> patterns = new ArrayList<Pattern>();

            for (String regex : regexs ) {
                patternsNotAllowed.add(Pattern.compile(regex));
            }
            //confContainer.setDocumentPatterns(patterns);
        }


    }

    public boolean dbmsConnectionActive() {
        return null != dbmsConnection;
    }


}