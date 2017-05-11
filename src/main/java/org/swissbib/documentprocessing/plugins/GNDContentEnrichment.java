package org.swissbib.documentprocessing.plugins;

import com.mongodb.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.net.*;
import java.text.MessageFormat;
import java.text.Normalizer;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.DataFormatException;
import java.util.zip.Inflater;



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



    private HashMap<String,List<String>> test = new HashMap<>();


    private static Logger gndProcessing;
    private static Logger macsProcessing;
    private static Logger gndProcessingError;
    private static Proxy proxy;
    private static Pattern idPattern;
    private static String urlToSource;
    //private static ArrayList<GNDTagValues>  tagsToUse;
    private static ArrayList<String>  simpleTagsToUse;
    private static ArrayList<String>  simpleTagsToUseForMACS;
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
    private static String responseFieldMACS = null;
    private static RemoveDuplicates duplicateDetection;
    private static boolean inProductionMode = false;

    //private static final HashMap<String,HashMap<String,List<String>>> gndRules;
    //private static final HashMap<String,List<String>> gndValues;

    private static final TransformerFactory transformerFactory;
    private static Transformer gndTransformer = null;



    //private static BufferedWriter logFile = null;

    static {
        GNDContentEnrichment.gndProcessing = LoggerFactory.getLogger("gndProcessing");
        GNDContentEnrichment.gndProcessingError = LoggerFactory.getLogger("gndProcessingError");
        GNDContentEnrichment.macsProcessing = LoggerFactory.getLogger("macsProcessing");

        //tagsToUse = new ArrayList<GNDTagValues>();
        simpleTagsToUse = new ArrayList<String>();
        simpleTagsToUseForMACS = new ArrayList<String>();

        initialized = false;
        errorInitializing = false;
        gndLogOpen = false;

        /* rules Silvia
        gndRules = new HashMap<>();
        gndRules.put("500",new HashMap<>());
        gndRules.get("500").put("4", Arrays.asList("nawi","pseu"));
        gndRules.put("510",new HashMap<>());
        gndRules.get("510").put("4", Arrays.asList("vorg","nach","nazw"));
        gndRules.put("550",new HashMap<>());
        gndRules.get("550").put("4", Arrays.asList("vorg","nach","nazw"));
        gndRules.put("551",new HashMap<>());
        gndRules.get("551").put("4", Arrays.asList("vorg","nach","nazw"));

        gndValues = new HashMap<>();
        gndValues.put("500",Arrays.asList("a","b","c","d","q"));
        gndValues.put("510",Arrays.asList("a","b"));
        gndValues.put("550",Arrays.asList("a"));
        gndValues.put("551",Arrays.asList("a"));
        */
        transformerFactory = TransformerFactory.newInstance();
        try {
            InputStream in = GNDContentEnrichment.class.getResourceAsStream("gnd500.xsl");
            gndTransformer = transformerFactory.newTransformer(new StreamSource(in));
        } catch (TransformerConfigurationException c) {
            //gndTransformer = null;

            c.printStackTrace();
        }


    }

    //http://www.oxygenxml.com/doc/ug-editor/tasks/generate-certificate.html


    @Override
    public void initPlugin(HashMap<String, String> configuration) {

        //in any case if the method is called the plugin will be marked as initialized
        //an error during initialization might occur - but this is another case

        String className =  this.getClass().getName();
        if (configuration.containsKey("PLUGINS.IN.PRODUCTIONMODE") && configuration.get("PLUGINS.IN.PRODUCTIONMODE").contains(className) )
            inProductionMode = true;
        else
            return;


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


    public String getReferences5xxConcatenated(String gndID) {

        String toReturn = "";

        if (!this.checkReadyForProcessing()) return toReturn;



        if (!errorInitializing) {

            StringBuilder concatReferences = new StringBuilder();

            BasicDBObject query = null;
            DBCursor cursor = null;
            try {
                query = new BasicDBObject(searchField, gndID);
                cursor = searchCollection.find(query);
                boolean append = false;

                while (cursor.hasNext()) {
                    DBObject dbObject =  cursor.next();
                    byte[] data = (byte[])dbObject.get("record");

                    Optional<String> unzippedRecord = this.getDeCompressedRecord(data,gndID);

                    if (unzippedRecord.isPresent()) {

                        //System.out.println(unzippedRecord.get());
                        //String completeRecord = unzippedRecord.get();
                        //StringReader strReader = new StringReader(unzippedRecord.get());

                        //Source gndRecord = new StreamSource(new StringReader(testRecord()));
                        Source gndRecord = new StreamSource(new StringReader(unzippedRecord.get()));
                        StringWriter result = new StringWriter();
                        Result xsltResultHoldings = new StreamResult(result);
                        gndTransformer.transform(gndRecord,xsltResultHoldings);
                        String extractedGNDValues = result.toString();
                        if (!extractedGNDValues.isEmpty()) {

                            //System.out.println(extractedGNDValues);
                            //expected format of the result:
                            //500XLIMITERX###dies ist b###only test
                            //510XLIMITERX###dies ist b
                            for (String line: extractedGNDValues.split("\n")) {
                                if (line.isEmpty() ) continue; //do not consider empty lines
                                String[] lineElements = line.split("XLIMITERX");
                                if (lineElements.length == 2) {
                                    append = true;
                                    String elements = lineElements[1];
                                    String[] tokens = elements.split("###");
                                    for (String token : tokens) {
                                        if (token.isEmpty()) continue;
                                        concatReferences.append(token).append("##xx##");
                                    }


                                }else {
                                    gndProcessingError.error("getReferences5xxConcatenated - result from xslt not correct, got %s");
                                }


                            }

                        }

                    }

                }

                toReturn = concatReferences.toString();
                if (append) {
                    toReturn = toReturn.substring(0,toReturn.length()-6);
                }

            } catch (Exception excep) {

                gndProcessingError.error("Error reading from Mongo DB in getReferences5xxConcatenated", excep);


            } finally {
                if (cursor != null){
                    cursor.close();
                }
            }
            //to suppress duplicates makes sense because we collect values from GND and MACS and merge them together which might produce duplicates
            toReturn = duplicateDetection.removeDuplicatesFromMultiValuedField(toReturn);

            if (! toReturn.isEmpty()) {
                gndProcessing.debug("getReferencesConcatenated: gndID: " + gndID + " / references: " + toReturn);
            }

        }

        return toReturn;
    }



    public String getReferencesConcatenated(String gndID) {

        String toReturn = "";

        if (checkReadyForProcessing()) return toReturn;


        if (!errorInitializing) {

            StringBuilder concatReferences = new StringBuilder();

            BasicDBObject query = null;
            DBCursor cursor = null;
            try {
                query = new BasicDBObject(searchField, gndID);
                cursor = searchCollection.find(query);
                boolean append = false;

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

                    if (responseFieldMACS != null) {

                        BasicDBObject  macsField =  (BasicDBObject)dbObject.get(responseFieldMACS);

                        Set< Map.Entry <String,Object>> keyValuesMacs = macsField.entrySet();
                        Iterator<Map.Entry<String,Object>>   itMacs =  keyValuesMacs.iterator();
                        while (itMacs.hasNext()) {
                            Map.Entry<String,Object> entry = itMacs.next();
                            String key = entry.getKey();
                            if (simpleTagsToUseForMACS.contains(key)) {

                                BasicDBList dbList  = (BasicDBList)entry.getValue();
                                Iterator<Object> macsValues = dbList.iterator();

                                StringBuilder macsReferences = new StringBuilder();
                                boolean appendMACS = false;
                                while (macsValues.hasNext()) {
                                    append = true;
                                    appendMACS = true;
                                    String value = (String)macsValues.next();
                                    String composedValue = Normalizer.normalize(value, Normalizer.Form.NFC);
                                    //System.out.println(composedValue);

                                    //only for logging
                                    macsReferences.append(composedValue).append("##xx##");
                                    concatReferences.append(composedValue).append("##xx##");

                                }
                                if (appendMACS) {
                                    String macsValuesForLogging = macsReferences.toString();
                                    macsValuesForLogging = macsValuesForLogging.substring(0,macsValuesForLogging.length()-6);
                                    macsValuesForLogging = duplicateDetection.removeDuplicatesFromMultiValuedField(macsValuesForLogging);
                                    macsProcessing.info("additional MACS values for GND " + gndID + " : " + macsValuesForLogging);
                                }
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
            //to suppress duplicates makes sense because we collect values from GND and MACS and merge them together which might produce duplicates
            toReturn = duplicateDetection.removeDuplicatesFromMultiValuedField(toReturn);
            gndProcessing.debug("getReferencesConcatenated: gndID: " + gndID + " / references: " + toReturn);

        }


        return toReturn;

    }


    private boolean checkReadyForProcessing() {

        if (!inProductionMode) return false;

        if (!initialized)  {
            initDefaultValues();


        }

        return true;
    }


    private String testRecord () {

        StringBuilder sb = new StringBuilder();
        sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>").
                append("<record type=\"Authority\" xmlns=\"http://www.loc.gov/MARC21/slim\">")
                .append("<datafield tag=\"500\" ind1=\" \" ind2=\" \">")
                .append("<subfield code=\"4\">nawi</subfield>")
                .append("<subfield code=\"0\">(DE-101)041530985</subfield>")
                .append("<subfield code=\"c\">only test</subfield>")
                .append("<subfield code=\"0\">(uri)http://d-nb.info/gnd/4153098-6</subfield>")
                .append("<subfield code=\"b\">dies ist b in 500</subfield>")
                .append("</datafield>")
                .append("<datafield tag=\"510\" ind1=\" \" ind2=\" \">")
                .append("<subfield code=\"4\">vorg</subfield>")
                .append("<subfield code=\"0\">(DE-101)041530985</subfield>")
                .append("<subfield code=\"0\">(DE-588)4153098-6</subfield>")
                .append("<subfield code=\"0\">(uri)http://d-nb.info/gnd/4153098-6</subfield>")
                .append("<subfield code=\"b\">dies ist b in 510</subfield>")
                .append("</datafield>")
                .append("</record>");

        return sb.toString();


    }


    private Optional<String> getDeCompressedRecord(byte[] zippedByteStream, String gndid) {
        Optional<String> opt = Optional.empty();

        try {
            Inflater decompresser = new Inflater();
            decompresser.setInput(zippedByteStream);
            ByteArrayOutputStream bos = new ByteArrayOutputStream(zippedByteStream.length);
            byte[] buffer = new byte[8192];
            while (!decompresser.finished()) {
                int size = decompresser.inflate(buffer);
                bos.write(buffer, 0, size);
            }
            opt = Optional.of(bos.toString());
            decompresser.end();
        } catch (DataFormatException dfe) {
            gndProcessing.error(String.format("couldn't get the zipped GND record from id: %s", gndid));
        }

        return opt;
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
        String sTagsToUseForMACS = configuration.get("TAGS.TO.USE.FOR.MACS");


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

        if (sTagsToUseForMACS != null && sTagsToUseForMACS.length()>0) {
            String[] aTagsToUse =  sTagsToUseForMACS.split("###");
            for (String tag: aTagsToUse) {

                //I don't need this for the Mongo solution but won't throw it away so far

                //String[] dataFieldSubField = tag.split("_");
                //if (null != dataFieldSubField && dataFieldSubField.length == 2) {
                //    GNDTagValues tags = new GNDTagValues(dataFieldSubField[0], dataFieldSubField[1]);
                //    tagsToUse.add(tags);
                //}

                simpleTagsToUseForMACS.add(tag);

            }

        }



    }

    private void initializeMongoConnection(HashMap<String, String> configuration)
        throws  Exception
    {


        try {

            String[] mongoClient = configuration.get("MONGO.CLIENT").split("###");
            String[] mongoAuthentication = null;

            if (configuration.containsKey("MONGO.AUTHENTICATION")) {
             mongoAuthentication = configuration.get("MONGO.AUTHENTICATION").split("###");
            }

            ServerAddress server = new ServerAddress(mongoClient[0], Integer.valueOf(mongoClient[1]));
            String[] mongoDB = configuration.get("MONGO.DB").split("###");

            DB db = null;
            if (mongoAuthentication != null ) {
                MongoCredential credential = MongoCredential.createMongoCRCredential(mongoAuthentication[1], mongoAuthentication[0], mongoAuthentication[2].toCharArray());
                mClient = new MongoClient(server, Arrays.asList(credential));
                db =  mClient.getDB(mongoAuthentication[0]);
            }
            else {
                mClient = new MongoClient(server);
                db =  mClient.getDB(mongoDB[0]);
            }


            //simple test if authentication was successfull
            CommandResult cR = db.getStats();

            if (cR != null && !cR.ok()) {
                throw new Exception("authentication against database wasn't possible - no GND Processing will take place when type is called from XSLT templates");
            }


            nativeSource = mClient.getDB(mongoDB[0]);
            searchCollection = nativeSource.getCollection(mongoDB[1]);
            searchField = mongoDB[2];
            responseField = mongoDB[3];
            if (mongoDB.length > 4) {
                responseFieldMACS = mongoDB[4];
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

}


