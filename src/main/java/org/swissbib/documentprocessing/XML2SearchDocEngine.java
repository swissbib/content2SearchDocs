package org.swissbib.documentprocessing;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.swissbib.documentprocessing.exceptions.XML2SolrException;
import org.swissbib.documentprocessing.exceptions.XML2SolrInitException;
import org.swissbib.documentprocessing.plugins.IDocProcPlugin;
import org.swissbib.documentprocessing.solr.XML2SOLRDocEngine;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
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



public abstract class XML2SearchDocEngine {



    //we need a pattern which detects lines with a record tag
    protected static final Pattern recordline ;
    protected static  final String ls ;
    protected static final Logger marcXMLlogger ;
    protected static final Logger marc2SolrExceptionlogger;
    protected static final Logger marc2SolrInitExceptionlogger;
    //private static ConfigContainer confContainer = null;
    protected static final String fs;

    protected static HashMap<String,String> configuration;

    protected static ArrayList <IDocProcPlugin> plugins ;
    protected static int gSizeNumberOfDocs;

    protected static boolean mandatoryPropertiesInitialized;

    protected Transformer skipTransformer = null;

    private ArrayList<String> xpathDirs = null;




    static  {
        recordline = Pattern.compile("<record");
        ls = System.getProperties().getProperty("line.separator");
        marcXMLlogger = LoggerFactory.getLogger(XML2SOLRDocEngine.class);
        marc2SolrExceptionlogger = LoggerFactory.getLogger(XML2SolrException.class);
        marc2SolrInitExceptionlogger = LoggerFactory.getLogger(XML2SolrInitException.class);
        fs = System.getProperties().getProperty("file.separator");
        configuration = new HashMap<String, String>();
        plugins = new ArrayList<IDocProcPlugin>();
        gSizeNumberOfDocs = 0;
        mandatoryPropertiesInitialized = false;

    }


    protected ArrayList<Transformer> transformers = new ArrayList<Transformer>();

    protected TransformerFactory transformerFactory = null;

//--input=/swissbib_index/solrDocumentProcessing/MarcToSolr/data/inputfilesInitial/job1r20A002.no_holdings.xml --conf=/home/swissbib/swissbib/code_checkout_svn/solr_lucene/config.properties --outputdir=/swissbib_index/solrDocumentProcessing/MarcToSolr/data/outputfiles --xpath=/home/swissbib/swissbib/code_checkout_svn/solr_lucene/xslt



    public static void main (String[] args) {

        marcXMLlogger.info("Start of Processing in main method");


        try {

            String targetSearchEngine = System.getProperty("TARGET.SEARCHENGINE");
            Class tClass = Class.forName(targetSearchEngine);
            XML2SearchDocEngine xmlDocsEngine = (XML2SearchDocEngine)tClass.newInstance();


            marcXMLlogger.info("Initializing the XML2SOLR engine");
            xmlDocsEngine.initMandatoryTransformationProps(System.getProperties());
            xmlDocsEngine.initFileProperties();

            xmlDocsEngine.runTransformation();



        } catch (XML2SolrInitException initException) {
            initException.printStackTrace();
            marcXMLlogger.error("InitException -> more information in Exception log");
            marc2SolrInitExceptionlogger.error(initException.getMessage());
            for (StackTraceElement sE: initException.getStackTrace()) {
                marc2SolrInitExceptionlogger.error(sE.toString());
            }

        } catch (ClassNotFoundException classNotFound) {


            classNotFound.printStackTrace();
            marcXMLlogger.error("InitException -> more information in Exception log");
            marc2SolrInitExceptionlogger.error(classNotFound.getMessage());
            for (StackTraceElement sE: classNotFound.getStackTrace()) {
                marc2SolrInitExceptionlogger.error(sE.toString());
            }

        } catch (IllegalAccessException illegalAccess) {

            illegalAccess.printStackTrace();
            marcXMLlogger.error("InitException -> more information in Exception log");
            marc2SolrInitExceptionlogger.error(illegalAccess.getMessage());
            for (StackTraceElement sE: illegalAccess.getStackTrace()) {
                marc2SolrInitExceptionlogger.error(sE.toString());
            }

        } catch (InstantiationException instantException) {

            instantException.printStackTrace();
            marcXMLlogger.error("InitException -> more information in Exception log");
            marc2SolrInitExceptionlogger.error(instantException.getMessage());
            for (StackTraceElement sE: instantException.getStackTrace()) {
                marc2SolrInitExceptionlogger.error(sE.toString());
            }

        }


    }





    protected void initXSLTTransformers() throws TransformerConfigurationException {

        System.setProperty("javax.xml.transform.TransformerFactory",getTransformerImplementation());

        transformerFactory = TransformerFactory.newInstance();


        if (skipRecords()) {
            skipTransformer = transformerFactory.newTransformer(getSearchedStreamSource(getxPathDirs(),configuration.get("XSLTTEMPLATESKIP")));
        }

    }

    abstract protected void makeTransformations(Writer writer, String record) throws TransformerException;


    protected void runTransformation() {
        try {


            File fInputFile =  new File(configuration.get("INPUT.FILE"));

            marcXMLlogger.info("Processing inputfile: " + configuration.get("INPUT.FILE"));

            BufferedReader readerStream = new BufferedReader(new InputStreamReader( new FileInputStream(fInputFile),"UTF-8"));
            String line = null;



            initXSLTTransformers();


            BufferedWriter fileIntermediateResultOut = null;
            if (isWriteIntermediateResult()) {
                fileIntermediateResultOut =
                        new  BufferedWriter(new OutputStreamWriter(new FileOutputStream( getIntermediateResultsFile()),"UTF-8"));
            }


            //FulltextContentEnrichment.init(confContainer);
            long filecounter = 1;
            String formatCounter = String.format("%06d",filecounter);
            BufferedWriter fout = openNewOutPutFile(getBaseNameFileSolrDocs(),configuration.get("OUTPUT.DIR"), formatCounter);
            //BufferedWriter fout = new StringWriter();
            writeFileHeader(fout);
            int lineCounter = 0;
            long lineSum = 0;

            long numberRecordsweededOut = 0;
            long totalNumberOfRecords = 0;

            while ((line = readerStream.readLine()) != null ) {
                lineCounter++;
                if (recordline.matcher(line).find())
                {

                    totalNumberOfRecords++;

                    try {

                        //for distributed search repositories
                        //int bucketNumber = Math.abs(getBucketNumber(line,"docid",2));

                        if (skipRecords()) {

                            StringWriter sw = new StringWriter();
                            Source source = new StreamSource(new StringReader(line));
                            Result tempXsltResult = new StreamResult(sw);

                            try {
                                skipTransformer.transform(source,tempXsltResult);

                                boolean belongs2Repository = Boolean.valueOf(sw.toString());

                                if (!belongs2Repository) {
                                    numberRecordsweededOut++;

                                    continue;

                                    //todo: make logging

                                }
                            } catch (TransformerException transformerExc) {
                                //todo better logging
                                transformerExc.printStackTrace();
                            }
                        }

                        makeTransformations(fout,line);

                        lineSum++;
                        fout.write(ls);
                        if (lineCounter % 50 == 0 ) {
                            fout.flush();
                        }
                        if (lineCounter % getNumberSOLRDocs() == 0) {

                            writeFileFooter(fout);
                            fout.flush();
                            fout.close();

                            filecounter++;
                            formatCounter = String.format("%06d",filecounter);
                            fout = openNewOutPutFile(getBaseNameFileSolrDocs(),configuration.get("OUTPUT.DIR".toUpperCase())   ,formatCounter);
                            writeFileHeader(fout);

                        }

                    } catch (Throwable ex) {

                        StringBuilder builder = new StringBuilder();
                        builder.append("Problem processing the record \n").append(line).append("\n\n");
                        builder.append("reason\n\n").append(ex.getMessage()).append("\n\nAttention: the solr document format might be corrupted for current inputfile");
                        marc2SolrExceptionlogger.error(builder.toString());

                    }
                }

            }
            if (null != fout) {
                writeFileFooter(fout);
                fout.flush();
                fout.close();
            }
            else {
                marc2SolrExceptionlogger.error("warum null?");
                marc2SolrExceptionlogger.error(line);
            }

            marcXMLlogger.info("total number of records in package: " + totalNumberOfRecords);
            marcXMLlogger.info("number of documents processed for search engine: " + lineSum);
            marcXMLlogger.info("number of documents skipped: " + numberRecordsweededOut);


        }  catch (FileNotFoundException fnfEx) {
            marcXMLlogger.error("File Not Found Exception -> more information in Exception log");

            marc2SolrExceptionlogger.error(fnfEx.getMessage());
            for (StackTraceElement sE: fnfEx.getStackTrace()) {
                marc2SolrExceptionlogger.error(sE.toString());
            }

            fnfEx.printStackTrace();
        }  catch (UnsupportedEncodingException unsEncoding) {

            marcXMLlogger.error("Unsupported Encoding Exception -> more information in Exception log");
            marc2SolrExceptionlogger.error(unsEncoding.getMessage());
            for (StackTraceElement sE: unsEncoding.getStackTrace()) {
                marc2SolrExceptionlogger.error(sE.toString());
            }
            unsEncoding.printStackTrace();


        }  catch (TransformerConfigurationException transConfigEx) {

            marcXMLlogger.error("Transformer Configuration Exception -> more information in Exception log");
            marc2SolrExceptionlogger.error(transConfigEx.getMessage());
            for (StackTraceElement sE: transConfigEx.getStackTrace()) {
                marc2SolrExceptionlogger.error(sE.toString());
            }

            transConfigEx.printStackTrace();
        }  catch (IOException ioEx) {

            marcXMLlogger.error("IO Exception -> more information in Exception log");
            marc2SolrExceptionlogger.error(ioEx.getMessage());
            for (StackTraceElement sE: ioEx.getStackTrace()) {
                marc2SolrExceptionlogger.error(sE.toString());
            }

            ioEx.printStackTrace();
        } catch (Throwable th) {

            marcXMLlogger.error("Throwable Exception -> more information in Exception log");
            marc2SolrExceptionlogger.error(th.getMessage());
            for (StackTraceElement sE: th.getStackTrace()) {
                marc2SolrExceptionlogger.error(sE.toString());
            }

            th.printStackTrace();
        } finally {

            for (IDocProcPlugin plugin : plugins) {
                plugin.finalizePlugIn();
            }


            //necessary??
            //FulltextContentEnrichment.finalizeTika();
        }

        marcXMLlogger.info("End of processing");




    }



    protected void initMandatoryTransformationProps(Properties mandatoryProps) throws XML2SolrInitException {

        marcXMLlogger.info("\n\n\n\n\n\ninitialization of mandatory program arguments");


        String[] tMandatoryProps = new String[] {"CONF.ADDITIONAL.PROPS.FILE","INPUT.FILE","OUTPUT.DIR","XPATH.DIR","SKIPRECORDS"};

        //Properties programProps = new Properties();


        for (String ts : tMandatoryProps) {
            if (!mandatoryProps.containsKey(ts)) {

                throw new XML2SolrInitException(new Exception("missing mandatory property: " + ts));

            } else {
                configuration.put(ts.toUpperCase(),mandatoryProps.getProperty(ts)) ;

            }
        }

        mandatoryPropertiesInitialized = true;

    }


    protected void initFileProperties() throws XML2SolrInitException {



        try {


            if (!XML2SearchDocEngine.mandatoryPropertiesInitialized) {

                Exception ex = new Exception("no initialization of mandatory program properties");
                throw new XML2SolrInitException(ex);

            }


            //now load the initialization done via property file
            File configFile = new File(configuration.get("CONF.ADDITIONAL.PROPS.FILE"));
            FileInputStream fi = new FileInputStream(configFile);
            Properties configProps = new Properties();
            configProps.load(fi);

            Enumeration<Object> propKeys  = configProps.keys();

            while (propKeys.hasMoreElements()) {
                String key = (String)propKeys.nextElement();
                configuration.put(key.toUpperCase(),(String) configProps.getProperty(key));
            }


            //are there any configured plugins?
            if (configuration.containsKey("PLUGINS.TO.LOAD".toUpperCase())){

                String pluginsConf = configuration.get("PLUGINS.TO.LOAD");
                ArrayList<String> pluginClassNames = new ArrayList<String>();
                pluginClassNames.addAll(Arrays.asList(pluginsConf.split("###")));


                for (String cName : pluginClassNames ) {
                    try {
                        Class tClass = Class.forName(cName);
                        IDocProcPlugin docProcPlugin = (IDocProcPlugin)tClass.newInstance();
                        docProcPlugin.initPlugin(configuration);
                        plugins.add(docProcPlugin);
                    } catch (ClassNotFoundException nfE) {
                        nfE.printStackTrace();
                    } catch (InstantiationException instE) {
                        instE.printStackTrace();
                    }  catch (IllegalAccessException illegalAccessE) {
                        illegalAccessE.printStackTrace();
                    }
                    //patterns.add(Pattern.compile(regex));
                }

            }

            marcXMLlogger.info("\n => loaded properties (mandatory and file: ");
            for(String key: configuration.keySet()){

                System.out.println("=> key: " + key + "   ===>>>>   " + configuration.get(key));
                marcXMLlogger.info("\n => key: " + key + "   ===>>>>   " + configuration.get(key));

            }


        }  catch (FileNotFoundException fNFEx) {

            throw new XML2SolrInitException(fNFEx);

        } catch (IOException ioEx) {

            throw new XML2SolrInitException(ioEx);

        }  catch (Exception ex)  {
            throw new XML2SolrInitException(ex);
        }



    }


    protected String getTransformerImplementation() {

        String implementation = configuration.get("TRANSFORMERIMPL");
        //marcXMLlogger.info("\n => Loading TRANSFORMERIMPL: " + implementation);
        return null != implementation && implementation.length() > 0 ? implementation :"net.sf.saxon.TransformerFactoryImpl" ;
    }

    protected void writeFileFooter(BufferedWriter fout)
            throws IOException {

        //fout.write(ls);
        //fout.write("</add>");
        fout.flush();
    }

    protected void writeFileHeader(Writer fout)
            throws IOException {

        //fout.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        //fout.write("<add>");
        //fout.write(ls);
        fout.flush();
    }



    protected boolean isWriteIntermediateResult() {

        String implementation = configuration.get("INTERMEDIATE.RESULT.OUTPUT.DIR.FILE");
        return null != implementation && implementation.length() > 0;

    }

    protected int getNumberSOLRDocs() {
        int iSize = 1000;

        if (gSizeNumberOfDocs > 0){
            iSize = gSizeNumberOfDocs;

        } else {
            String size = configuration.get("SOLRDOCSIZE".toUpperCase());
            //marcXMLlogger.info("\n => Loading BASENAME.FILE.SOLRDOCS: " + implementation);
            if (null != size && Integer.valueOf(size) > 0) {
                iSize = Integer.valueOf(size);
            }

        }
        return iSize;

    }


    protected ArrayList<Source> getStreamSourcen() {
        String xsltTemplates = configuration.get("XSLTTEMPLATES");
        if (null == xsltTemplates || xsltTemplates.length() <= 0 ) {
            xsltTemplates = "swissbib.solr.xslt";
        }

        //marcXMLlogger.info("\n => Loading XSLTTEMPLATES: " + xsltTemplates);
        String[] templates = xsltTemplates.split("##");
        ArrayList<Source> sourcen  = new ArrayList<Source>();

        for (String template : templates) {

            //String p = configuration.get("XPATH.DIR") + fs +  template;
            sourcen.add(getSearchedStreamSource(getxPathDirs(),template) );
        }

        return sourcen;

    }


    //protected Source getHoldingsSource() {


    //    String holdingsTemplate = configuration.get("COLLECT.HOLDINGS.TEMPLATE");
    //    String path = configuration.get("XPATH.DIR") + fs +  holdingsTemplate;
    //    return   new StreamSource(path);
    //}


    //protected Source getWeedingSource() {


    //    String weedTemplate = configuration.get("WEEDHOLDINGS.TEMPLATE");
    //    String path = configuration.get("XPATH.DIR") + fs +  weedTemplate;
    //    return   new StreamSource(path);
    //}



    protected String getIntermediateResultsFile() {

        String implementation = configuration.get("INTERMEDIATE.RESULT.OUTPUT.DIR.FILE");
        //marcXMLlogger.info("\n => Loading INTERMEDIATE.RESULT.OUTPUT: " + implementation);
        return null != implementation && implementation.length() > 0 ? implementation : "" ;

    }





    protected BufferedWriter openNewOutPutFile(String filename,
                                             String baseOutputdirectory,
                                             String filecounter)
            throws IOException {

        String [] partsOfName = filename.split("\\.");
        String newFileName = partsOfName[0] + filecounter + "." + partsOfName[1];

        File subDir = new File(baseOutputdirectory);
        boolean exists = true;
        if (!subDir.exists()) {
            exists = subDir.mkdir();
        }


        return exists? new BufferedWriter(new OutputStreamWriter(new FileOutputStream( subDir + File.separator + newFileName),"UTF-8")): null;

    }




    protected String getBaseNameFileSolrDocs() {

        String implementation = configuration.get("BASENAME.FILE.SOLRDOCS");
        //marcXMLlogger.info("\n => Loading BASENAME.FILE.SOLRDOCS: " + implementation);
        return null != implementation && implementation.length() > 0 ? implementation : "searchDoc.xml" ;


    }


    protected boolean skipRecords () {

        return Boolean.valueOf(configuration.get("SKIPRECORDS"));
    }


    protected ArrayList<String> getxPathDirs () {


        if (this.xpathDirs == null) {

            String xPathes = configuration.get("XPATH.DIR");
            this.xpathDirs = new ArrayList<String>();
            xpathDirs.addAll(Arrays.asList(xPathes.split("###")));
        }

        return this.xpathDirs;
    }


    protected StreamSource getSearchedStreamSource(ArrayList<String> directories, String filename) {

        StreamSource source = null;

        for (String baseDir : directories) {

            String path = baseDir + fs +  filename;

            if (new File(path).exists())  {

                source =   new StreamSource(path);
                break;
            }
        }

        return source;

    }

}
