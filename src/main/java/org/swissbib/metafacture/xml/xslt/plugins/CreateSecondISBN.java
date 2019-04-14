package org.swissbib.metafacture.xml.xslt.plugins;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.swissbib.metafacture.xml.xslt.helper.PipeConfig;

import java.util.HashMap;
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



public class CreateSecondISBN implements IXSLTPlugin {

    private final static String ISBNDelimiiterPattern = "[\\-\\.]";
    private final static Pattern ISBNPattern = Pattern.compile("^.*?(?:\\A|\\D)(\\d{9})[\\dXx](?:\\Z|\\D).*$");
    private final static Pattern LongISBNPattern = Pattern.compile("^.*?(?:\\A|\\D)(\\d{13})(?:\\Z|\\D).*$");



    //Muster wie folgt sollen ausgefiltert werden
    //978-3-89602-841-9  super Euro Preis  => 978-3-89602-841-9
    private final static Pattern normalizePattern = Pattern.compile("(^[0-9Xx-]+)( .*$)?");





    @Override
    public void initPlugin(PipeConfig configuration) {

        System.out.print("in ISBN Plugin");

    }

    @Override
    public void finalizePlugIn() {

    }


    public String getAlternativeISBN(String isbnToModify) {
        return "123";

    }


    public static Boolean matches(String isbn) throws IllegalArgumentException {
        isbn = isbn.replaceAll(ISBNDelimiiterPattern, "");
        Matcher m = ISBNPattern.matcher(isbn);
        return m.matches();
        // Matcher m2 = ISBN13Pattern.matcher(isbn);
        // return m.matches() && !m2.matches();
    }



}
