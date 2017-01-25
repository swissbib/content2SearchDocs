package org.swissbib.documentprocessing.plugins;


import java.util.*;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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



public class CreateSecondISBN implements IDocProcPlugin {

    private final static String ISBNDelimiiterPattern = "[\\-\\.]";
    private final static Pattern ISBNPattern = Pattern.compile("^.*?(?:\\A|\\D)(\\d{9})[\\dXx](?:\\Z|\\D).*$");
    private final static Pattern LongISBNPattern = Pattern.compile("^.*?(?:\\A|\\D)(\\d{13})(?:\\Z|\\D).*$");


    private static Logger isbnCreatorLog;

    //Muster wie folgt sollen ausgefiltert werden
    //978-3-89602-841-9  super Euro Preis  => 978-3-89602-841-9
    private final static Pattern normalizePattern = Pattern.compile("(^[0-9Xx-]+)( .*$)?");


    static {
        isbnCreatorLog = LoggerFactory.getLogger(CreateSecondISBN.class);
    }



    @Override
    public void initPlugin(HashMap<String, String> configuration) {

        isbnCreatorLog.info("initialization of CreateSecondISBN Plugin");

    }

    @Override
    public void finalizePlugIn() {

        isbnCreatorLog.info("finalize CreateSecondISBN Plugin");
    }


    public String getAlternativeISBN(String isbnToModify) {

        String isbnToReturn = isbnToModify;

        try {
            if (!this.isNormalizable(isbnToModify)) {
                return isbnToModify;
            }

            String tIsbnToModify = this.normalizeISBN(isbnToModify);

            if (this.isValidISBN10(tIsbnToModify)) {

                //String isbnToReturn1  = this.isbnShortToLong(tIsbnToModify);
                //String isbnTorReturn2 = this.isbnShortToLongVuFind(tIsbnToModify);
                //assert isbnToReturn1.equalsIgnoreCase(isbnTorReturn2);

                isbnToReturn = this.isbnShortToLongVuFind(tIsbnToModify);

            } else if (this.isValidISBN13(tIsbnToModify)) {

                isbnToReturn = this.isbnLongToShort(tIsbnToModify);

            }
        } catch (Throwable ex ) {

            //todo: activate logging
            System.out.println(ex.getMessage());
            //isbnToReturn = isbnToModify;

        }

        return isbnToReturn;

    }


    public static Boolean matches(String isbn) throws IllegalArgumentException {
        isbn = isbn.replaceAll(ISBNDelimiiterPattern, "");
        Matcher m = ISBNPattern.matcher(isbn);
        return m.matches();
        // Matcher m2 = ISBN13Pattern.matcher(isbn);
        // return m.matches() && !m2.matches();
    }


    private String isbnShortToLong(String isbn) {
        //http://commons.apache.org/proper/commons-validator/apidocs/org/apache/commons/validator/routines/ISBNValidator.html

        //Beschreibung des Algorithmus 10 zu 13
        //http://isbn-information.com/isbn-information/convert-isbn-10-to-isbn-13.html

        isbn = isbn.replaceAll(ISBNDelimiiterPattern, "");
        // Does it match a long one? If so, return it
        Matcher m = LongISBNPattern.matcher(isbn);
        if (m.matches()) {
            // System.out.println(isbn + " is long");
            return m.group(1);
        }
        // System.out.println(isbn);
        m = ISBNPattern.matcher(isbn);
        if (!m.matches()) {
            // System.out.println(isbn + " did not match");
            throw new IllegalArgumentException(isbn + ": Not an ISBN");
        }

        // Matcher m2 = ISBN13Pattern.matcher(isbn);
        // if (m2.matches()) {
        // throw new IllegalArgumentException(isbn + ": Already 13 digits");
        // }

        String longisbn = "978" + m.group(1);

        int[] digits = new int[12];
        for (int i=0;i<12;i++) {
            digits[i] = new Integer(longisbn.substring(i, i+1));
        }

        Integer sum = 0;
        for (int i = 0; i < 12; i++) {
            sum = sum + digits[i] + (2 * digits[i] * (i % 2));
        }
        // Get the smallest multiple of ten > sum
        Integer top = sum + (10 - (sum % 10));
        Integer check = top - sum;
        if (check == 10) {
            return longisbn + "0";
        } else {
            return longisbn + check.toString();
        }


    }


    /*
    similar to VuFind implemantation short to long
    VuFindCode\ISBN::get13()
    probably a litlle bit faster although not tested so far
     */
    private String isbnShortToLongVuFind (String isbn) {

        String start = "978" +  isbn.substring(0,9);
        return start + this.getISBN13CheckDigit(start);
    }


    private String isbnLongToShort(String isbn13) {

        isbn13 = isbn13.replaceAll(ISBNDelimiiterPattern, "");

        String modifiedISBN = isbn13;
        if ((isbn13.length()  == 13) && isbn13.substring(0,3).equals("978") ) {
            String start = isbn13.substring(3,12);
            start += this.getISBN10CheckDigit(start);
            modifiedISBN = start;
        }

        return modifiedISBN;

    }



    private String normalizeISBN(String raw) {

        String normalizedValue = null;
        if (this.isNormalizable(raw)) {
            raw = raw.trim();
            Matcher m = normalizePattern.matcher(raw);
            normalizedValue = m.matches() ? m.group(1).replace("-","").toUpperCase() : raw;
        } else {
            normalizedValue = raw;
        }
        return normalizedValue;
    }

    private boolean isNormalizable(String raw) {
        return raw != null && raw.length() > 0 ;
    }


    private boolean isValidISBN10 (String isbn) {
        return  isbn.length() == 10 && this.getISBN10CheckDigit(isbn.substring(0,9)).equalsIgnoreCase(isbn.substring(9,10));
    }


    private boolean isValidISBN13 (String isbn) {
        return isbn.length() == 13 && this.getISBN13CheckDigit(isbn.substring(0, 12)).equalsIgnoreCase(isbn.substring(12,13));
    }



    private String getISBN10CheckDigit (String isbnToCheck) {

        int sum = 0;
        for (int x = 0; x < isbnToCheck.length(); x++) {
            sum += Integer.parseInt(isbnToCheck.substring( x, x + 1)) * (1 + x);
        }
        int checkdigit = sum % 11;
        return checkdigit == 10 ? "X" : String.valueOf(checkdigit);
    }

    private String getISBN13CheckDigit(String isbn)
    {
        int sum = 0;
        int weight = 1;
        for (int x = 0; x < isbn.length(); x++) {
            sum +=  Integer.valueOf(isbn.substring( x, x + 1)) * weight;
            weight = weight == 1 ? 3 : 1;
        }
        int retval = 10 - (sum % 10);
        return retval == 10 ? "0" : String.valueOf(retval);
    }

}
