package org.swissbib.documentprocessing.plugins;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;

/**
 * [...description of the type ...]
 * <p/>
 * <p/>
 * <p/>
 * Copyright (C) project swissbib, University Library Basel, Switzerland
 * http://www.swissbib.org  / http://www.swissbib.ch / http://www.ub.unibas.ch
 * <p/>
 * Date: 08/01/19
 * Time: 15:30 PM
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
 * @link https://github.com/swissbib/content2SearchDocs
 */


public class CreateLibraryFacets implements IDocProcPlugin {


    private static Logger facetLibraryLogger;

    static {

        //so far I haven't defined this Logger in Log4J configuration
        CreateLibraryFacets.facetLibraryLogger = LoggerFactory.getLogger("facetLibraries");
    }


    @Override
    public void initPlugin(HashMap<String, String> configuration) {

        //todo
        //1) read configuration LIBADMIN_DEFINITIONS (I already added this key into the config vonfigGreen.properties)
        //1a) you have to add this plugin type to the config keys PLUGINS.TO.LOAD and PLUGINS.IN.PRODUCTIONMODE
        //(already done)
        //2) load resource and parse it (my proposal: include jackson dependency for this
        //3) prepare json structure as we have spoken about this morning (better usable Json - document)
        //4) reference this prepared structure internally for later use
        //5) write Junit tests for it. Related to Jackson and tests compare
        //https://gitlab.com/swissbib/classic/kafka-cbs-consumer/tree/master/src/main/java/org/swissbib/kafka/consumer
        //Erweiterung des XSLT templates - entweder innerhalb einer bestehenden Schablone
        //z.B. hier https://github.com/swissbib/content2SearchDocs/blob/master/xslt/swissbib.solr.vufind2.xsl#L1433
        //oder eigene neue Schablone.
        //Innerhalb dieser neuen Schablone muss dann dieses Plugin aufgerufen werden.
        //Wie man das im template am besten macht weiss Silvia sicher am besten. Den notwendigen Rahmen, Definition deises Plugins
        //im Kopf des templates habe ich bereits gemacht

    }

    @Override
    public void finalizePlugIn() {
        //todo cleanup resources if necessary
    }


    /*
    The signature of the method depends on waht we need in the xslt template
    Actually my guess: it's an organization code like A100 (or do we have something on a higher level)
    Of course the method structure is not limited to only one parameter
    If you need more than one method (which has to be called explicitly by the xlst client) you can define them
     */
    public String readURLContent(String organizationCode) {

        //todo
        //process the method value

        //should be the desired structure
        return "";
    }
}
