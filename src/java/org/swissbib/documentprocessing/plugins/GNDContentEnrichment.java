package org.swissbib.documentprocessing.plugins;

import com.mongodb.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.net.*;
import java.text.MessageFormat;
import java.text.Normalizer;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * [...description of the type ...]
 * <p/>
 * <p/>
 * <p/>
 * Copyright (C) project swissbib, University Library Basel, Switzerland
 * http://www.swissbib.org  / http://www.swissbib.ch / http://www.ub.unibas.ch
 * <p/>
 * Date: 12/19/12
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



public class GNDContentEnrichment implements IDocProcPlugin{


    private static Logger gndProcessing;
    private static Logger gndProcessingError;
    private static Proxy proxy;
    private static Pattern idPattern;
    private static String urlToSource;
    //private static ArrayList<GNDTagValues>  tagsToUse;
    private static ArrayList<String>  simpleTagsToUse;
    private static String idPatternForReplacement;

    //it is possible to initiaze with default values
    private static boolean initialized;

    //an error occured while trying to initialize -> processing shouldn't take place
    private static boolean errorInitializing;
    private static boolean gndLogOpen;

    private static DB nativeSource = null;
    private static MongoClient mClient = null;
    private static DBCollection searchCollection = null;
    private static String searchField = "";
    private static String responseField = "";
    private static RemoveDuplicates duplicateDetection;

    //private static BufferedWriter logFile = null;

    static {
        GNDContentEnrichment.gndProcessing = LoggerFactory.getLogger("gndProcessing");
        GNDContentEnrichment.gndProcessingError = LoggerFactory.getLogger("gndProcessingError");

        //tagsToUse = new ArrayList<GNDTagValues>();
        simpleTagsToUse = new ArrayList<String>();

        initialized = false;
        errorInitializing = false;
        gndLogOpen = false;


    }

    //http://www.oxygenxml.com/doc/ug-editor/tasks/generate-certificate.html


    @Override
    public void initPlugin(HashMap<String, String> configuration) {

        //in any case if the method is called the plugin will be marked as initialized
        //an error during initialization might occur - but this is another case
        initialized = true;

        try {

            //urlToSource = configuration.get("SOURCE.TO.FETCH.GND");
            idPatternForReplacement = configuration.get("ID.PATTERN.TO.REPLACE");
            initializeMongoConnection(configuration);

            //initializeProxy(configuration);
            //initializeIDPattern(configuration);
            initializeTagsToUse(configuration);

            duplicateDetection = new RemoveDuplicates();
            duplicateDetection.initPlugin(configuration);


        } catch (Exception ex) {
            errorInitializing = true;
            //initialized = false;
        }


    }

    @Override
    public void finalizePlugIn() {
        if (mClient != null) {
            mClient.close();
        }
    }


    public String getReferencesConcatenated(String gndID) {

        String toReturn = "";
        if (!initialized)  {
            initDefaultValues();
            writeLog("late initialized");

        }

        if (!errorInitializing) {

            StringBuilder concatReferences = new StringBuilder();

            BasicDBObject query = new BasicDBObject(searchField, gndID);
            DBCursor cursor = searchCollection.find(query);
            boolean append = false;

            try {
                    while (cursor.hasNext()) {
                        DBObject dbObject =  cursor.next();
                        BasicDBObject  gndFields =  (BasicDBObject)dbObject.get(responseField);

                        Set< Map.Entry <String,Object>> keyValues = gndFields.entrySet();
                        Iterator<Map.Entry<String,Object>>   it =  keyValues.iterator();
                        while (it.hasNext()) {
                            Map.Entry<String,Object> entry = it.next();
                            String key = entry.getKey();
                            if (simpleTagsToUse.contains(key)) {

                                BasicDBList dbList  = (BasicDBList)entry.getValue();
                                Iterator<Object> gndValues = dbList.iterator();
                                while (gndValues.hasNext()) {
                                    append = true;
                                    String value = (String)gndValues.next();
                                    String composedValue = Normalizer.normalize(value, Normalizer.Form.NFC);
                                    //System.out.println(composedValue);
                                    concatReferences.append(composedValue).append("##xx##");

                                }
                            }

                        }

                    }

                    toReturn = concatReferences.toString();
                    if (append) {
                        toReturn = toReturn.substring(0,toReturn.length()-6);

                    }

            } catch (Exception excep) {

                excep.printStackTrace();


            } finally {
                if (cursor != null){
                    cursor.close();
                }
            }
            toReturn = duplicateDetection.removeDuplicatesFromMultiValuedField(toReturn);
            gndProcessing.debug("getReferencesConcatenated: gndID: " + gndID + " / references: " + toReturn);

        }


        return toReturn;



          //old way using the SRU interface of DNB for each request
//        StringBuilder concatReferences = new StringBuilder();
//
//        //1. get the id we can use to fetch GND record
//        String tgndid = gndID;
//        writeLog("tgnid: " + tgndid);
//        Matcher  matcher = idPattern.matcher(tgndid);
//        boolean append = false;
//        if (matcher.find()) {
//
//            try {
//
//                tgndid = matcher.group(2);
//                writeLog("matched number: " + tgndid);
//                String url = MessageFormat.format(urlToSource,tgndid);
//
//                HttpURLConnection connection = getHTTPConnection (url);
//                InputStream is = (InputStream) connection.getContent();
//                MarcXmlReader marcReader = new MarcXmlReader(is);
//
//                while (marcReader.hasNext()) {
//                    Record record = marcReader.next();
//
//                    Iterator iter  = record.getDataFields().iterator();
//
//                    while (iter.hasNext()) {
//                        DataField df = (DataField)iter.next();
//
//                        for (GNDTagValues tags: tagsToUse) {
//                            if(df.getTag().equalsIgnoreCase(tags.tagValue)) {
//                                append = true;
//                                concatReferences.append(df.getSubfield('a').getData()).append("##xx##");
//                            }
//                        }
//
//                    }
//
//                }
//
//
//                if (null != is)  {
//                    is.close();
//                }
//
//            }catch (IOException ioEx) {
//                ioEx.printStackTrace();
//                gndProcessingError.error("getReferencesConcatenated","IOException ",ioEx);
//                //ioEx.printStackTrace();
//
//            } catch (Exception exc) {
//                exc.printStackTrace();
//                gndProcessingError.error("getReferencesConcatenated","Exception ",exc);
//            } catch (Throwable thr) {
//                thr.printStackTrace();
//                gndProcessingError.error("getReferencesConcatenated","Throwable ",thr);
//            }
//
//
//
//        }
//
//
//        String toReturn = concatReferences.toString();
//        if (append) {
//            toReturn = toReturn.substring(0,toReturn.length()-6);
//            gndProcessing.info("getReferencesConcatenated", "gndID: " + gndID + " / references: " + toReturn);
//        }
//
//        writeLog("toReturn: " + toReturn);
//        return toReturn;

    }



    public String getReferencesAsXML(String gndID) {

        String referencesAsXML = "";


        if (!initialized)  {
            initDefaultValues();
        }


        //1. get the id we can use to fetch GND record
        String tgndid = gndID;
        Matcher  matcher = idPattern.matcher(tgndid);
        boolean append = false;
        if (matcher.find()) {

            try {


                tgndid = matcher.group(2);



                //2. build the url to fetch gnd record
                String url = MessageFormat.format(urlToSource,tgndid);

                HttpURLConnection connection = getHTTPConnection (url);
                InputStream is = (InputStream) connection.getContent();
                referencesAsXML = new Scanner( is ).useDelimiter( "\\Z" ).next();

                //3. finally close the connection
                if ( is != null )
                    is.close();

            }catch (IOException ioEx) {
                gndProcessingError.error("getReferencesAsXML","IOException ",ioEx);
                //ioEx.printStackTrace();

            } catch (Exception exc) {

                gndProcessingError.error("getReferencesAsXML","Exception ",exc);
            } catch (Throwable thr) {
                gndProcessingError.error("getReferencesAsXML","Throwable ",thr);
            }

        }

        return referencesAsXML;
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

                gndProcessing.info("proxy - object: " + proxyProp + " initialized");

            }catch (Throwable th) {

                gndProcessingError.error("\n => Error while creating Proxy");
                gndProcessingError.error(th.getMessage());
                proxy = null;

            }

        }
    }

    private void initializeIDPattern(HashMap<String, String> configuration) {

        if (configuration.containsKey("PATTERN.FOR.ID")) {
            idPattern = Pattern.compile(configuration.get("PATTERN.FOR.ID"));
        }
    }

    private void initializeTagsToUse(HashMap<String, String> configuration) {
        String sTagsToUse = configuration.get("TAGS.TO.USE");


        if (sTagsToUse != null && sTagsToUse.length()>0) {

            String[] aTagsToUse =  sTagsToUse.split("###");

            for (String tag: aTagsToUse) {

                //I don't need this for the Mongo solution but won't throw it away so far

                //String[] dataFieldSubField = tag.split("_");
                //if (null != dataFieldSubField && dataFieldSubField.length == 2) {
                //    GNDTagValues tags = new GNDTagValues(dataFieldSubField[0], dataFieldSubField[1]);
                //    tagsToUse.add(tags);
                //}

                simpleTagsToUse.add(tag);

            }

        }

    }

    private void initializeMongoConnection(HashMap<String, String> configuration)
        throws  Exception
    {


        try {

            String[] mongoClient = configuration.get("MONGO.CLIENT").split("###");
            String[] mongoAuthentication = configuration.get("MONGO.AUTHENTICATION").split("###");
            String[] mongoDB = configuration.get("MONGO.DB").split("###");



            mClient = new MongoClient( mongoClient[0],Integer.valueOf(mongoClient[1]));

            DB db =  mClient.getDB(mongoAuthentication[0]);

            boolean authenticated = db.authenticate(mongoAuthentication[1],mongoAuthentication[2].toCharArray());
            if (authenticated) {

                nativeSource = mClient.getDB(mongoDB[0]);
                searchCollection = nativeSource.getCollection(mongoDB[1]);
                searchField = mongoDB[2];
                responseField = mongoDB[3];

            } else {
                throw new Exception("authentication against database wasn't possible - no GND Processing will take place when type is called from XSLT templates");

            }


        } catch (UnknownHostException uHE) {
            gndProcessingError.error("MongoError", "Mongo Connection couldn't be established");
            gndProcessingError.error("MongoError",uHE);
            uHE.printStackTrace();
            throw uHE;

        } catch (Exception  ex) {
            gndProcessingError.error("MongoError", "General Exception while trying to connect to Mongo");
            gndProcessingError.error("MongoError",ex);
            ex.printStackTrace();
            throw ex;

        }
    }


    private HttpURLConnection getHTTPConnection (String url) throws IOException

    {
        HttpURLConnection uc = null;

            URL u = new URL(url);
            if (proxy != null) {
                uc = (HttpURLConnection)u.openConnection(proxy);
                uc.setReadTimeout(1000);
                uc.connect();

            } else {

                uc = (HttpURLConnection)u.openConnection();
                uc.setReadTimeout(1000);
                uc.connect();
            }



        return uc;

    }


    private void initDefaultValues () {
        HashMap<String,String>   configuration = new HashMap<String, String>();
        //configuration.put("SOURCE.TO.FETCH.GND","https://portal.dnb.de/opac.htm?method=requestMarcXml&idn={0}");
        configuration.put("ID.PATTERN.TO.REPLACE","?##?");
        //configuration.put("PATTERN.FOR.ID","^(\\(.*?\\))(.*)$");
        configuration.put("TAGS.TO.USE","450_a");

        //try {
            //logFile = new BufferedWriter(new OutputStreamWriter(new FileOutputStream( "/home/swissbib/gnd.log"),"UTF-8"));
        //    gndLogOpen = true;

        //} catch (FileNotFoundException fnfEx) {
        //    fnfEx.printStackTrace();
        //} catch (UnsupportedEncodingException usEnc) {
        //    usEnc.printStackTrace();
        //}


        initPlugin(configuration);

    }


    private void writeLog (String message) {
//        if (gndLogOpen) {
//            try {
//                logFile.write(message + "\n");
//            } catch (IOException ioExc) {
//                ioExc.printStackTrace();
//            }
//        }

    }



}


//class GNDTagValues {

//    public String tagValue;
//    public String subFieldValue;

//    public GNDTagValues(String tag, String subfield) {
//        this.tagValue = tag;
//        this.subFieldValue = subfield;
//    }

//}
