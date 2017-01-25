package org.swissbib.documentprocessing.elasticsearch;

import org.swissbib.documentprocessing.XML2SearchDocEngine;

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
 * Date: 5/29/13
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


public class XML2ESDocEngine extends XML2SearchDocEngine {

    protected Transformer weedingsTransformer;
    protected Transformer holdingsTransformer;



    @Override
    protected void initXSLTTransformers() throws TransformerConfigurationException {

        super.initXSLTTransformers();




        for(Source source: getStreamSourcen()) {

            transformers.add(transformerFactory.newTransformer(source));
        }


        Source weedingsSource = getSearchedStreamSource(getxPathDirs(),configuration.get("WEEDHOLDINGS.TEMPLATE"));
        weedingsTransformer = transformerFactory.newTransformer(weedingsSource);
        Source holdingsSource = getSearchedStreamSource(getxPathDirs(),configuration.get("COLLECT.HOLDINGS.TEMPLATE"));
        holdingsTransformer = transformerFactory.newTransformer(holdingsSource);

    }

    @Override
    protected void makeTransformations(Writer writer, String record) throws TransformerException {


        Source sourceHoldings = new StreamSource(new StringReader(record));
        Source sourceWeeding = new StreamSource(new StringReader(record));

        StringWriter holdings = new StringWriter();
        StringWriter weededRecord = new StringWriter();

        Result xsltResultHoldings = new StreamResult(holdings);
        holdingsTransformer.transform(sourceHoldings,xsltResultHoldings);
        //System.out.println(holdings.toString());


        Result xsltResultWeeding = new StreamResult(weededRecord);
        weedingsTransformer.transform(sourceWeeding,xsltResultWeeding);
        //System.out.println(weededRecord.toString());

        Source source = new StreamSource(new StringReader(weededRecord.toString()));

        for (int index = 0; index < transformers.size(); index++) {


            if (index == transformers.size() - 1) {

                //write it to fout in the last transformation step
                Result tempXsltResult = new StreamResult(writer);

                transformers.get(index).setParameter("holdingsStructure",holdings.toString().replaceAll("\n",""));
                transformers.get(index).setParameter("recordStructure",weededRecord.toString().replaceAll("\n",""));

                //StringWriter test = new StringWriter();
                //Result testResult  = new StreamResult(test);

                transformers.get(index).transform(source, tempXsltResult);
                //transformers.get(index).transform(source, testResult);
                //System.out.println(test.toString());


            } else  {

                //bei Zwischenschritten in der Transformation in einen String schreiben

                StringWriter sw = new StringWriter();
                Result tempXsltResult = new StreamResult(sw);
                transformers.get(index).transform(source,tempXsltResult);

                //if (isWriteIntermediateResult()) {
                //    fileIntermediateResultOut.write(sw.toString() + ls);
                //}
                source = new StreamSource(new StringReader(sw.toString()));
            }
        }



    }






    @Override
    protected String getBaseNameFileSolrDocs() {

        String implementation = configuration.get("BASENAME.FILE.ESDOCS");
        //marcXMLlogger.info("\n => Loading BASENAME.FILE.SOLRDOCS: " + implementation);
        return null != implementation && implementation.length() > 0 ? implementation : "elasticsearchOut.json" ;


    }


}
