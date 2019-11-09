package org.swissbib.flink;

import org.apache.flink.api.common.functions.RichMapFunction;
import org.apache.flink.api.common.typeinfo.TypeInformation;
import org.apache.flink.api.common.typeinfo.Types;
import org.apache.flink.api.java.typeutils.ResultTypeQueryable;
import org.apache.flink.configuration.Configuration;
//import org.swissbib.SbMetadataModel;
import org.swissbib.SbMetadataDeserializer;
import org.swissbib.SbMetadataModel;
import org.swissbib.documentprocessing.MFXsltBasedBridge;
import org.swissbib.types.CbsActions;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class DocProcFunction extends RichMapFunction<SbMetadataModel,SbMetadataModel>
        implements ResultTypeQueryable<SbMetadataModel> {


    MFXsltBasedBridge bridge2pipe;
    private static Pattern p = Pattern.compile("<record .*?>");


    @Override
    public SbMetadataModel map(SbMetadataModel record) throws Exception {

        String test = "<record type=\"Bibliographic\" xmlns=\"http://www.loc.gov/MARC21/slim\"><leader>     cam a22     4  4500</leader><controlfield tag=\"001\">175553726</controlfield><controlfield tag=\"003\">CHVBK</controlfield><controlfield tag=\"005\">20191025034131.0</controlfield><controlfield tag=\"007\">cr |||||||||||</controlfield><controlfield tag=\"008\">001120s1609    it      s     00    ita|d</controlfield><datafield ind1=\"7\" ind2=\" \" tag=\"024\"><subfield code=\"a\">10.3931/e-rara-75685</subfield><subfield code=\"2\">doi</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"035\"><subfield code=\"a\">(OCoLC)470081727</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"035\"><subfield code=\"a\">(NEBIS)006593741</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"040\"><subfield code=\"a\">BDF</subfield><subfield code=\"d\">SzZuIDS NEBIS ZBZ</subfield></datafield><datafield ind1=\"1\" ind2=\" \" tag=\"100\"><subfield code=\"a\">Tasso</subfield><subfield code=\"D\">Torquato</subfield><subfield code=\"d\">1544-1595</subfield><subfield code=\"0\">(DE-588)118620916</subfield></datafield><datafield ind1=\"1\" ind2=\"0\" tag=\"245\"><subfield code=\"a\">Della Gierusalemme</subfield><subfield code=\"c\">conquistata del S. Torquato Tasso libri XXIV, con gli argomenti a ciascun libro Sig. Gio. Battista Massarengo et la tavola de principii di tutte le stanze</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"250\"><subfield code=\"a\">Novellamente ristampati</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"260\"><subfield code=\"a\">In Venetia</subfield><subfield code=\"b\">p. Bernardo Giunti &amp; Gio. Battista Ciotti</subfield><subfield code=\"c\">1609</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"300\"><subfield code=\"a\">720 S.</subfield><subfield code=\"b\">Ill.</subfield><subfield code=\"c\">11 cm (12°)</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"336\"><subfield code=\"a\">Text</subfield><subfield code=\"b\">txt</subfield><subfield code=\"2\">rdacontent/ger</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"337\"><subfield code=\"a\">Computermedien</subfield><subfield code=\"b\">c</subfield><subfield code=\"2\">rdamedia/ger</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"337\"><subfield code=\"a\">ohne Hilfsmittel zu benutzen</subfield><subfield code=\"b\">n</subfield><subfield code=\"2\">rdamedia/ger</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"338\"><subfield code=\"a\">Band</subfield><subfield code=\"b\">nc</subfield><subfield code=\"2\">rdacarrier/ger</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"338\"><subfield code=\"a\">Online-Ressource</subfield><subfield code=\"b\">cr</subfield><subfield code=\"2\">rdacarrier/ger</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"500\"><subfield code=\"a\">Titeleinfassung</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"590\"><subfield code=\"a\">Aus dem Vorbesitz von Johann Jakob Bodmer gemäss handschriftlicher Liste seiner Bibliothek Ms Bodmer 38a. Pergamenteinband</subfield></datafield><datafield ind1=\"1\" ind2=\" \" tag=\"700\"><subfield code=\"a\">Massarengo</subfield><subfield code=\"D\">Giovanni Battista</subfield><subfield code=\"d\">1569-1596</subfield><subfield code=\"0\">(DE-588)128458569</subfield></datafield><datafield ind1=\"1\" ind2=\" \" tag=\"700\"><subfield code=\"a\">Ciotti</subfield><subfield code=\"D\">Giovanni Battista</subfield><subfield code=\"d\">1564-1635</subfield><subfield code=\"0\">(DE-588)119641828</subfield><subfield code=\"e\">Drucker</subfield><subfield code=\"4\">prt</subfield></datafield><datafield ind1=\"1\" ind2=\" \" tag=\"700\"><subfield code=\"a\">Bodmer</subfield><subfield code=\"D\">Johann Jakob</subfield><subfield code=\"d\">1698-1783</subfield><subfield code=\"0\">(DE-588)118512315</subfield><subfield code=\"4\">fmo</subfield></datafield><datafield ind1=\"0\" ind2=\" \" tag=\"710\"><subfield code=\"a\">Giunta, Bernardo</subfield><subfield code=\"4\">bkd</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"751\"><subfield code=\"a\">Venedig</subfield><subfield code=\"0\">(DE-588)4062501-1</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"856\"><subfield code=\"u\">https://doi.org/10.3931/e-rara-75685</subfield><subfield code=\"z\">Online via e-rara.ch</subfield><subfield code=\"x\">Z01</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"898\"><subfield code=\"a\">BK020053</subfield><subfield code=\"b\">XK020053</subfield><subfield code=\"c\">XK020000</subfield></datafield><datafield ind1=\" \" ind2=\"7\" tag=\"909\"><subfield code=\"a\">MedeaZBZ</subfield><subfield code=\"c\">lomb</subfield><subfield code=\"2\">idszbz ZR</subfield></datafield><datafield ind1=\" \" ind2=\"7\" tag=\"909\"><subfield code=\"a\">MedeaZBZ</subfield><subfield code=\"b\">SWK</subfield><subfield code=\"2\">idszbz ZR</subfield></datafield><datafield ind1=\" \" ind2=\"7\" tag=\"909\"><subfield code=\"a\">Z01erara</subfield><subfield code=\"2\">idszbz Z1</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"949\"><subfield code=\"B\">NEBIS</subfield><subfield code=\"C\">ZAD50</subfield><subfield code=\"D\">EBI01</subfield><subfield code=\"E\">006593741</subfield><subfield code=\"F\">Z01</subfield><subfield code=\"b\">Z06</subfield><subfield code=\"c\">RAM</subfield><subfield code=\"j\">25.897</subfield><subfield code=\"p\">ZM02519509</subfield><subfield code=\"q\">006593741</subfield><subfield code=\"r\">000010</subfield><subfield code=\"0\">ZB Alte Drucke</subfield><subfield code=\"1\">A.Drucke, Magazin 06</subfield><subfield code=\"2\">4</subfield><subfield code=\"3\">BOOK</subfield><subfield code=\"4\">22</subfield><subfield code=\"5\">Benutzung im Lesesaal</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"949\"><subfield code=\"B\">NEBIS</subfield><subfield code=\"C\">ZAD50</subfield><subfield code=\"D\">EBI01</subfield><subfield code=\"E\">006593741</subfield><subfield code=\"F\">Z01</subfield><subfield code=\"b\">Z01</subfield><subfield code=\"c\">OL</subfield><subfield code=\"p\">ZD3688384</subfield><subfield code=\"q\">006593741</subfield><subfield code=\"r\">000020</subfield><subfield code=\"0\">ZB (Zürich)</subfield><subfield code=\"1\">Online ZB</subfield><subfield code=\"2\">4</subfield><subfield code=\"3\">DIGIT</subfield><subfield code=\"4\">60</subfield><subfield code=\"5\">Online</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"950\"><subfield code=\"B\">NEBIS</subfield><subfield code=\"P\">100</subfield><subfield code=\"E\">1-</subfield><subfield code=\"a\">Tasso</subfield><subfield code=\"D\">Torquato</subfield><subfield code=\"d\">1544-1595</subfield><subfield code=\"0\">(DE-588)118620916</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"950\"><subfield code=\"B\">NEBIS</subfield><subfield code=\"P\">700</subfield><subfield code=\"E\">1-</subfield><subfield code=\"a\">Massarengo</subfield><subfield code=\"D\">Giovanni Battista</subfield><subfield code=\"d\">1569-1596</subfield><subfield code=\"0\">(DE-588)128458569</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"950\"><subfield code=\"B\">NEBIS</subfield><subfield code=\"P\">700</subfield><subfield code=\"E\">1-</subfield><subfield code=\"a\">Ciotti</subfield><subfield code=\"D\">Giovanni Battista</subfield><subfield code=\"d\">1564-1635</subfield><subfield code=\"0\">(DE-588)119641828</subfield><subfield code=\"e\">Drucker</subfield><subfield code=\"4\">prt</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"950\"><subfield code=\"B\">NEBIS</subfield><subfield code=\"P\">856</subfield><subfield code=\"E\">--</subfield><subfield code=\"u\">https://doi.org/10.3931/e-rara-75685</subfield><subfield code=\"z\">Online via e-rara.ch</subfield><subfield code=\"x\">Z01</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"950\"><subfield code=\"B\">NEBIS</subfield><subfield code=\"P\">700</subfield><subfield code=\"E\">1-</subfield><subfield code=\"a\">Bodmer</subfield><subfield code=\"D\">Johann Jakob</subfield><subfield code=\"d\">1698-1783</subfield><subfield code=\"0\">(DE-588)118512315</subfield><subfield code=\"4\">fmo</subfield></datafield><datafield ind1=\" \" ind2=\" \" tag=\"950\"><subfield code=\"B\">NEBIS</subfield><subfield code=\"P\">710</subfield><subfield code=\"E\">0-</subfield><subfield code=\"a\">Giunta, Bernardo</subfield><subfield code=\"4\">bkd</subfield></datafield></record>";

        //String response = bridge2pipe.transform(p.matcher(record.getData()).replaceAll("<record>"));
        String response = bridge2pipe.transform(p.matcher(test).replaceAll("<record>"));
        SbMetadataModel sbm = new SbMetadataModel();
        sbm.setData(response);
        sbm.setCbsAction(CbsActions.CREATE);
        return sbm;

    }

    @Override
    public void open(Configuration parameters) throws Exception {
        super.open(parameters);

        //bridge2pipe = MFXsltBasedBridge.build().
        //        setConfigFileName("pipeDefaultConfig.yaml");
        bridge2pipe = new MFXsltBasedBridge("pipeDefaultConfig.yaml");


        bridge2pipe.init();

    }

    @Override
    public void close() throws Exception {
        super.close();

    }

    @Override
    public TypeInformation<SbMetadataModel> getProducedType() {
        return Types.GENERIC(SbMetadataModel.class);
    }
}
