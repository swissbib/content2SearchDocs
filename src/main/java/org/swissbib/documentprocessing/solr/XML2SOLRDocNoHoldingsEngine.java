package org.swissbib.documentprocessing.solr;


import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;

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



public class XML2SOLRDocNoHoldingsEngine extends XML2SOLRDocEngine{


    @Override
    protected void initXSLTTransformers() throws TransformerConfigurationException {

        super.initXSLTTransformers();


        for(Source source: getStreamSourcen()) {

            this.transformers.add(transformerFactory.newTransformer(source));
        }



    }

    @Override
    protected void makeTransformations(Writer writer, String record) throws TransformerException{



        Source source = new StreamSource(new StringReader(record));

        for (int index = 0; index < transformers.size(); index++) {


            if (index == transformers.size() - 1) {

                //write it to fout in the last transformation step
                Result tempXsltResult = new StreamResult(writer);
                this.transformers.get(index).transform(source, tempXsltResult);

            } else  {

                //bei Zwischenschritten in der Transformation in einen String schreiben

                StringWriter sw = new StringWriter();
                Result tempXsltResult = new StreamResult(sw);
                this.transformers.get(index).transform(source,tempXsltResult);

                //if (isWriteIntermediateResult()) {
                //    fileIntermediateResultOut.write(sw.toString() + ls);
                //}
                source = new StreamSource(new StringReader(sw.toString()));
            }
        }




    }




}
