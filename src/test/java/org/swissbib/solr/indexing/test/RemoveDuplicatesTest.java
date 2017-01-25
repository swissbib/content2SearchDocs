package org.swissbib.solr.indexing.test;

import org.junit.Test;
import static org.junit.Assert.*;


import org.swissbib.documentprocessing.solr.XML2SOLRDocEngine;
import org.swissbib.documentprocessing.plugins.RemoveDuplicates;

/**
 * Created by IntelliJ IDEA.
 * User: swissbib
 * Date: 2/16/11
 * Time: 8:46 PM
 * To change this template use File | Settings | File Templates.
 */
public class RemoveDuplicatesTest {

    @Test
    public void testDeduplication() {

        RemoveDuplicates rd = new RemoveDuplicates();
        String back =   rd.removeDuplicatesFromMultiValuedField("aaa###bbbbb###aaa###");
        assertEquals ("number elements expected: ",2,back.split("###").length);

    }


    @Test
    public void testStartMainClass() {

        XML2SOLRDocEngine m = new XML2SOLRDocEngine();




    }


}
