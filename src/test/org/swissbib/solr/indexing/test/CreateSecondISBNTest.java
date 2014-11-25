package org.swissbib.solr.indexing.test;


import org.junit.Assert;
import org.junit.Test;

import org.swissbib.documentprocessing.plugins.CreateSecondISBN;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

/**
 * Created by IntelliJ IDEA.
 * User: swissbib
 * Date: 3/18/11
 * Time: 11:49 AM
 * To change this template use File | Settings | File Templates.
 */
public class CreateSecondISBNTest {

    private final static  String tenToThirteenNotOk = "Conversion ISBN10 -> ISBN13 not correct";
    private final static  String thirteenToTenNotOk = "Conversion ISBN13 -> ISBN10 not correct";

    @Test
    public void testIsbnShortToLong() {



        //13: 9783141007008
        String isbn10 = "3141007004";
        String isbn10_1 = "31-41-007-004";
        String isbn10_2 = "3-1-4-1-0-0-7-0-0-4";
        String isbn10_3 = "3-502-11918-X";

        String isbn10_4 = "3-502-11918-X mit bibliothekarischer Vielfalt";

        String isbn10_5 = "so viel Vielfalt geht nicht 3-502-11918-X mit bibliothekarischer Vielfalt";


        String isbn10_notok = "3-1-4-1-0-0-7-0-0-5";
        String isbn10_notok1 = "3-a-4-1-0-0-7-0-0-4";


        CreateSecondISBN isbnVariation = new CreateSecondISBN();


        //asserted values generated with: http://isbn13converter.pearsoned.com/isbn13/ or http://www.isbn.org/ISBN_converter

        Assert.assertEquals(tenToThirteenNotOk ,"9783141007008",isbnVariation.getAlternativeISBN(isbn10));
        Assert.assertEquals(tenToThirteenNotOk ,"9783141007008",isbnVariation.getAlternativeISBN(isbn10_1));
        Assert.assertEquals(tenToThirteenNotOk ,"9783141007008",isbnVariation.getAlternativeISBN(isbn10_2));
        Assert.assertEquals(tenToThirteenNotOk ,"9783502119180",isbnVariation.getAlternativeISBN(isbn10_3));
        Assert.assertEquals(tenToThirteenNotOk ,"9783502119180",isbnVariation.getAlternativeISBN(isbn10_4));
        Assert.assertEquals(tenToThirteenNotOk ,isbn10_5,isbnVariation.getAlternativeISBN(isbn10_5));

        Assert.assertEquals(tenToThirteenNotOk ,"3-1-4-1-0-0-7-0-0-5",isbnVariation.getAlternativeISBN(isbn10_notok));
        Assert.assertEquals(tenToThirteenNotOk ,"3-a-4-1-0-0-7-0-0-4",isbnVariation.getAlternativeISBN(isbn10_notok1));


    }


    @Test
    public void testIsbnLongToShort() {

        //was machen wir mit solchen Werten?
        //978-0-415-83537-4 (hbk.) : EUR 101.00<


        //13: 9783141007008
        String isbn13 = "978-1-55245-171-7";
        String isbn13_1 = "978-3-89602-841-9 ";
        String isbn13_2 = "978-3-446-43806-4";
        String isbn13_3 =  "978-3-502-11918-0";
        String isbn13_4 =  "978-3-502-11918-0 und noch etwas hintendran";
        String isbn13_5 =  "978-3-502-11918-0das geht nicht";



        //was machen wir mit Fällen in denen es bereits zwei Nummern gibt?
        //https://www.swissbib.ch/Record/320916081


        CreateSecondISBN isbnVariation = new CreateSecondISBN();

        Assert.assertEquals(thirteenToTenNotOk ,"1552451712",isbnVariation.getAlternativeISBN(isbn13));
        Assert.assertEquals(thirteenToTenNotOk ,"3896028413",isbnVariation.getAlternativeISBN(isbn13_1));
        Assert.assertEquals(thirteenToTenNotOk ,"3446438068",isbnVariation.getAlternativeISBN(isbn13_2));
        Assert.assertEquals(thirteenToTenNotOk ,"350211918X",isbnVariation.getAlternativeISBN(isbn13_3));
        Assert.assertEquals(thirteenToTenNotOk ,"350211918X",isbnVariation.getAlternativeISBN(isbn13_4));
        Assert.assertEquals(thirteenToTenNotOk ,isbn13_5,isbnVariation.getAlternativeISBN(isbn13_5));



    }

    @Test
    public void testSplitString() {


    }




}
