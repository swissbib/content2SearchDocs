package org.swissbib.documentprocessing.plugins;

import com.mongodb.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.UnknownHostException;
import java.text.Normalizer;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

/**
 * [...description of the type ...]
 * <p/>
 * <p/>
 * <p/>
 * Copyright (C) project swissbib, University Library Basel, Switzerland
 * http://www.swissbib.org  / http://www.swissbib.ch / http://www.ub.unibas.ch
 * <p/>
 * Date: 3/12/14
 * Time: 9:45 AM
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



public class DSV11ContentEnrichment implements IDocProcPlugin {


    private static boolean initialized;
    private static boolean errorInitializing;
    private static boolean dsv11LogOpen;

    private static Logger dsv11Processing;
    private static Logger dsv11ProcessingError;
    private static MongoClient mClient = null;
    private static DB nativeSource = null;
    private static DBCollection searchCollection = null;
    //private static String searchField = "";
    private static String responseField = "additionalvalues";
    private static RemoveDuplicates duplicateDetection;
    private static Pattern noSort =  Pattern.compile("<<.*?>>",Pattern.UNICODE_CASE | Pattern.DOTALL);
    private static Pattern createMatch = Pattern.compile("[\\W]", Pattern.UNICODE_CASE | Pattern.DOTALL);

    private static boolean inProductionMode = false;









    static {
        DSV11ContentEnrichment.dsv11Processing = LoggerFactory.getLogger("dsv11Processing");
        DSV11ContentEnrichment.dsv11ProcessingError = LoggerFactory.getLogger("dsv11ProcessingError");

        //tagsToUse = new ArrayList<GNDTagValues>();
        //simpleTagsToUse = new ArrayList<String>();

        initialized         = false;
        errorInitializing   = false;
        dsv11LogOpen        =  false;


    }




    public String getAdditionalDSV11Values(String currentTag, String tagValue) {

        String toReturn = "";

        if (!inProductionMode) return toReturn;

        if (!initialized)  {
            initDefaultValues();
            writeLog("late initialized");

        }

        String searchField = "match" + currentTag;


        if (!errorInitializing) {


            //tagValue = noSort.matcher(tagValue).replaceAll("");
            //tagValue = createMatch.matcher(tagValue).replaceAll("").toLowerCase();

            StringBuilder concatReferences = new StringBuilder();


            BasicDBObject query = new BasicDBObject(searchField, tagValue);
            DBCursor cursor = searchCollection.find(query);
            boolean append = false;

            try {
                while (cursor.hasNext()) {
                    DBObject dbObject =  cursor.next();
                    BasicDBObject  gndFields =  (BasicDBObject)dbObject.get(responseField);

                    Set< Map.Entry <String,Object>> keyValues = gndFields.entrySet();
                    Iterator<Map.Entry<String,Object>> it =  keyValues.iterator();
                    while (it.hasNext()) {
                        Map.Entry<String,Object> entry = it.next();
                        String key = entry.getKey();
                        //if (simpleTagsToUse.contains(key)) {

                            BasicDBList dbList  = (BasicDBList)entry.getValue();
                            Iterator<Object> dsv11Values = dbList.iterator();
                            while (dsv11Values.hasNext()) {
                                append = true;
                                String value = (String)dsv11Values.next();
                                value = noSort.matcher(value).replaceAll("");
                                String composedValue = Normalizer.normalize(value, Normalizer.Form.NFC);
                                //System.out.println(composedValue);
                                concatReferences.append(composedValue).append("##xx##");

                            }
                        //}

                    }

                }

                toReturn = concatReferences.toString();
                if (append) {
                    toReturn = toReturn.substring(0,toReturn.length()-6);
                    dsv11Processing.info("requested key and value: " + currentTag + " / " + tagValue );
                    dsv11Processing.info("added values from DSV11: " + toReturn);

                }

            } catch (Exception excep) {

                dsv11ProcessingError.debug("Error while looking for DSV11 values: " + excep.getMessage());
                excep.printStackTrace();


            } finally {
                if (cursor != null){
                    cursor.close();
                }
            }
            toReturn = duplicateDetection.removeDuplicatesFromMultiValuedField(toReturn);
            dsv11Processing.debug("getReferencesConcatenated: for tag: " + currentTag + " / tagValue " + tagValue + "\n" +
                    toReturn);

        }






        return toReturn;

    }



    @Override
    public void initPlugin(HashMap<String, String> configuration) {

        String className =  this.getClass().getName();
        if (configuration.containsKey("PLUGINS.IN.PRODUCTIONMODE") && configuration.get("PLUGINS.IN.PRODUCTIONMODE").contains(className) )
            inProductionMode = true;
        else
            return;


        //in any case if the method is called the plugin will be marked as initialized
        //an error during initialization might occur - but this is another case
        initialized = true;

        try {

            //urlToSource = configuration.get("SOURCE.TO.FETCH.GND");
            //idPatternForReplacement = configuration.get("ID.PATTERN.TO.REPLACE");
            initializeMongoConnection(configuration);

            //initializeProxy(configuration);
            //initializeIDPattern(configuration);
            //initializeTagsToUse(configuration);

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


    private void initializeMongoConnection(HashMap<String, String> configuration)
            throws  Exception
    {


        try {

            String[] mongoClient = configuration.get("MONGO.CLIENT").split("###");
            String[] mongoAuthentication = configuration.get("MONGO.AUTHENTICATION").split("###");
            String[] mongoDB = configuration.get("MONGO.DB.DSV11").split("###");



            mClient = new MongoClient( mongoClient[0],Integer.valueOf(mongoClient[1]));

            DB db =  mClient.getDB(mongoAuthentication[0]);

            boolean authenticated = db.authenticate(mongoAuthentication[1],mongoAuthentication[2].toCharArray());
            if (authenticated) {

                nativeSource = mClient.getDB(mongoDB[0]);
                searchCollection = nativeSource.getCollection(mongoDB[1]);
//                searchField = mongoDB[2];
//                responseField = mongoDB[3];

            } else {
                throw new Exception("authentication against database wasn't possible - no GND Processing will take place when type is called from XSLT templates");

            }


        } catch (UnknownHostException uHE) {
            dsv11ProcessingError.error("MongoError", "Mongo Connection couldn't be established");
            dsv11ProcessingError.error("MongoError",uHE);
            uHE.printStackTrace();
            throw uHE;

        } catch (Exception  ex) {
            dsv11ProcessingError.error("MongoError", "General Exception while trying to connect to Mongo");
            dsv11ProcessingError.error("MongoError",ex);
            ex.printStackTrace();
            throw ex;

        }
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
