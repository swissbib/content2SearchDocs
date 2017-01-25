package org.swissbib.documentprocessing.plugins;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;


/**
 * <p>
 *  The class is used to remove duplicate values from the original source record to be indexed
 *  </p>
 * <p>
 *  Most of the fields in the Solr index are defined as MultiValue fields which means that multiple field values of a document to be indexed
 *  are mapped to one field of the Solr-Schema definition.
 *  By now there is no mechanism delivered by Solr to remove such duplicate values
 *  </p>
 *  <p>
 *      possible would be to remove values placed at the same position of a field (usually used for synonyms) but this is not the case with multiple valued fields
 *   </p>
 *   <p>
 *       Although it wouldn't matter for facets when doubled values are used for facetting - but the scoring of the documents will be changed
 *       (term frequency and OmitNorms
 *       This is the reason why we remove this values during document processing
 *    </p>
 *    <p>
 *        Doing this with XSLT style sheets is far too complicated why Java extensions for XSLT are implemented
 *     </p>
 * <p/>
 * <p/>
 * <p/>
 * Copyright (C) project swissbib, University Library Basel, Switzerland
 * http://www.swissbib.org  / http://www.swissbib.ch / http://www.ub.unibas.ch
 * <p/>
 * Date: 2/16/11
 * Time: 3:13 PM
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



/**
 * Created by Guenter Hipler, project swissbib
 * Date: 2/16/11
 * Time: 3:13 PM
 * <p>
 *  The class is used to remove duplicate values from the original source record to be indexed
 *  </p>
 * <p>
  *  Most of the fields in the Solr index are defined as MultiValue fields which means that multiple field values of a document to be indexed
 *  are mapped to one field of the Solr-Schema definition.
 *  By now there is no mechanism delivered by Solr to remove such duplicate values
  *  </p>
 *  <p>
 *      possible would be to remove values placed at the same position of a field (usually used for synonyms) but this is not the case with multiple valued fields
 *   </p>
 *   <p>
 *       Although it wouldn't matter for facets when doubled values are used for facetting - but the scoring of the documents will be changed
 *       (term frequency and OmitNorms
 *       This is the reason why we remove this values during document processing
 *    </p>
 *    <p>
 *        Doing this with XSLT style sheets is far too complicated why Java extensions for XSLT are implemented
 *     </p>
  * @author Guenter Hipler, project swissbib
 * @version 0.1
 */

public class RemoveDuplicates implements IDocProcPlugin{
    /**
     *
     * @param inputValues a concatenated string using ### as separators
     * @return  a concatenated string (only unique values) / parts are separated with ###
     */

    private static Logger duplicatesLogger;
    static {

        Boolean debug = Boolean.valueOf(System.getProperty("LOGDEDUPLICATION","false")) ;
        if (debug) {
            duplicatesLogger =  LoggerFactory.getLogger(RemoveDuplicates.class);
        }
    }



    public String removeDuplicatesFromMultiValuedField(String inputValues) {

        if (null != duplicatesLogger) {
            duplicatesLogger.info("Values for Dedup: " + inputValues);
        }

        String[] splittedValues =   inputValues.split("##xx##");
        HashSet<String> uniqueSet = new HashSet<String>();
        uniqueSet.addAll(Arrays.asList(splittedValues));

        //System.out.println(uniqueSet.size());

        StringBuilder uniqueValues = new StringBuilder();

        int i = 1;
        int sizeOfSet = uniqueSet.size();
        for (String uniquevalue : uniqueSet) {
            uniqueValues.append(uniquevalue);
            if (i < sizeOfSet) {
                uniqueValues.append("##xx##");
            }
            i++;
        }

        if (null != duplicatesLogger) {
            duplicatesLogger.info("finished deduplication: " + uniqueValues.toString());
        }

        return uniqueValues.toString();
    }

    @Override
    public void initPlugin(HashMap<String, String> configuration) {
        //To change body of implemented methods use File | Settings | File Templates.
    }

    @Override
    public void finalizePlugIn() {
        //To change body of implemented methods use File | Settings | File Templates.
    }

}
