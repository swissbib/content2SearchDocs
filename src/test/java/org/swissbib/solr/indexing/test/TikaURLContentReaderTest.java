package org.swissbib.solr.indexing.test;

import org.junit.Test;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

import static org.junit.Assert.assertEquals;

/**
 * Created by IntelliJ IDEA.
 * User: swissbib
 * Date: 3/18/11
 * Time: 11:49 AM
 * To change this template use File | Settings | File Templates.
 */
public class TikaURLContentReaderTest {


    @Test
    public void testInit() {

        String configFile = "/home/swissbib/swissbib/code_checkout_svn/solr_lucene/config.properties";
        File file = new File(configFile);

        if (file.exists()) {

            try {
                FileInputStream fi = new FileInputStream(configFile);
                Properties configProps = new Properties();
                configProps.load(fi);

                //das hat sich geändert, kann so nicht mehr funktionieren
                //FulltextContentEnrichment.init(configProps);

            } catch (FileNotFoundException nfE) {
                nfE.printStackTrace();
            } catch (IOException ioE){
                ioE.printStackTrace();

            }



        }



    }


}
