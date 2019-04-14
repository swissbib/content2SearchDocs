package org.swissbib.metafacture.xml.xslt.plugins;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.swissbib.metafacture.xml.xslt.helper.PipeConfig;

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



public class GNDContentEnrichment implements IXSLTPlugin{





    @Override
    public void initPlugin(PipeConfig configuration) {


    }

    @Override
    public void finalizePlugIn() {
    }


    public String getReferences5xxConcatenated(String gndID) {


        return "references 5xx";
    }



    public String getReferencesConcatenated(String gndID) {



        return "references concatenate";

    }




    public String getReferencesAsXML(String gndID) {


        return "<xml>hier der content</xml>";
    }



}


