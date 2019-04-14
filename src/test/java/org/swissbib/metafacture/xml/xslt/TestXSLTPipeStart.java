package org.swissbib.metafacture.xml.xslt;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.swissbib.metafacture.xml.xslt.XSLTPipeStart;


class TestXSLTPipeStart {

    @Disabled("use it on a machine where professional saxon parser is installed")
    @Test
    void testStart() {

        XSLTPipeStart pipeStart = new XSLTPipeStart();
        pipeStart.setConfigFile("pipeConfig.test1.yaml");
        pipeStart.setTransformerFactory("net.sf.saxon.TransformerFactoryImpl");
        pipeStart.process(getTestRecord());
        System.out.println(pipeStart.getTransformationResultOfPipe().get());
        pipeStart.process(getTestRecord1());
        System.out.println(pipeStart.getTransformationResultOfPipe().get());
        pipeStart.process(getTestRecord());
        System.out.println(pipeStart.getTransformationResultOfPipe().get());
        pipeStart.process(getTestRecord1());
        System.out.println(pipeStart.getTransformationResultOfPipe().get());
        pipeStart.closeStream();
    }


    String getTestRecord() {
        return "<record type=\"Bibliographic\"><leader>     naa a22        4500</leader><controlfield tag=\"001\">509582699</controlfield><controlfield tag=\"003\">CHVBK</controlfield><controlfield tag=\"005\">20180411092709.0</controlfield><controlfield tag=\"007\">cr unu---uuuuu</controlfield><controlfield tag=\"008\">180411e20131001xx      s     000 0 eng  </controlfield><datafield tag=\"024\" ind1=\"7\" ind2=\"0\"><subfield code=\"a\">10.1007/s10909-013-0897-3</subfield><subfield code=\"2\">doi</subfield></datafield><datafield tag=\"035\" ind1=\" \" ind2=\" \"><subfield code=\"a\">(NATIONALLICENCE)springer-10.1007/s10909-013-0897-3</subfield></datafield><datafield tag=\"245\" ind1=\"0\" ind2=\"0\"><subfield code=\"a\">Call for Proposals: Proposed Sites to Host LT28 (in 2017)</subfield><subfield code=\"h\">[Elektronische Daten]</subfield></datafield><datafield tag=\"540\" ind1=\" \" ind2=\" \"><subfield code=\"a\">Springer Science+Business Media New York, 2013</subfield></datafield><datafield tag=\"773\" ind1=\"0\" ind2=\" \"><subfield code=\"t\">Journal of Low Temperature Physics</subfield><subfield code=\"d\">Springer US; http://www.springer-ny.com</subfield><subfield code=\"g\">173/1-2(2013-10-01), 3-3</subfield><subfield code=\"x\">0022-2291</subfield><subfield code=\"q\">173:1-2&#60;3</subfield><subfield code=\"1\">2013</subfield><subfield code=\"2\">173</subfield><subfield code=\"o\">10909</subfield></datafield><datafield tag=\"856\" ind1=\"4\" ind2=\"0\"><subfield code=\"u\">https://doi.org/10.1007/s10909-013-0897-3</subfield><subfield code=\"q\">text/html</subfield><subfield code=\"z\">Onlinezugriff via DOI</subfield></datafield><datafield tag=\"908\" ind1=\" \" ind2=\" \"><subfield code=\"D\">1</subfield><subfield code=\"a\">other</subfield><subfield code=\"2\">jats</subfield></datafield><datafield tag=\"950\" ind1=\" \" ind2=\" \"><subfield code=\"B\">NATIONALLICENCE</subfield><subfield code=\"P\">856</subfield><subfield code=\"E\">40</subfield><subfield code=\"u\">https://doi.org/10.1007/s10909-013-0897-3</subfield><subfield code=\"q\">text/html</subfield><subfield code=\"z\">Onlinezugriff via DOI</subfield></datafield><datafield tag=\"950\" ind1=\" \" ind2=\" \"><subfield code=\"B\">NATIONALLICENCE</subfield><subfield code=\"P\">773</subfield><subfield code=\"E\">0-</subfield><subfield code=\"t\">Journal of Low Temperature Physics</subfield><subfield code=\"d\">Springer US; http://www.springer-ny.com</subfield><subfield code=\"g\">173/1-2(2013-10-01), 3-3</subfield><subfield code=\"x\">0022-2291</subfield><subfield code=\"q\">173:1-2&#60;3</subfield><subfield code=\"1\">2013</subfield><subfield code=\"2\">173</subfield><subfield code=\"o\">10909</subfield></datafield><datafield tag=\"900\" ind1=\" \" ind2=\"7\"><subfield code=\"a\">Metadata rights reserved</subfield><subfield code=\"b\">Springer special CC-BY-NC licence</subfield><subfield code=\"2\">nationallicence</subfield></datafield><datafield tag=\"986\" ind1=\" \" ind2=\" \"><subfield code=\"a\">SWISSBIB</subfield><subfield code=\"b\">453793614</subfield></datafield><datafield tag=\"898\" ind1=\" \" ind2=\" \"><subfield code=\"a\">BK010053</subfield><subfield code=\"b\">XK010053</subfield><subfield code=\"c\">XK010000</subfield></datafield><datafield tag=\"949\" ind1=\" \" ind2=\" \"><subfield code=\"B\">NATIONALLICENCE</subfield><subfield code=\"E\">springer-10.1007/s10909-013-0897-3</subfield><subfield code=\"F\">NATIONALLICENCE</subfield><subfield code=\"b\">NL-springer</subfield><subfield code=\"u\">https://doi.org/10.1007/s10909-013-0897-3</subfield></datafield></record>";
    }

    String getTestRecord1() {
        return "<record type=\"Bibliographic\"><leader>     naa a22        4500</leader><controlfield tag=\"001\">509582850</controlfield><controlfield tag=\"003\">CHVBK</controlfield><controlfield tag=\"005\">20180411084151.0</controlfield><controlfield tag=\"007\">cr unu---uuuuu</controlfield><controlfield tag=\"008\">180411e20130501xx      s     000 0 eng  </controlfield><datafield tag=\"024\" ind1=\"7\" ind2=\"0\"><subfield code=\"a\">10.1007/s10909-012-0806-1</subfield><subfield code=\"2\">doi</subfield></datafield><datafield tag=\"035\" ind1=\" \" ind2=\" \"><subfield code=\"a\">(NATIONALLICENCE)springer-10.1007/s10909-012-0806-1</subfield></datafield><datafield tag=\"245\" ind1=\"0\" ind2=\"0\"><subfield code=\"a\">Spin Turbulence Made by the Oscillating Magnetic Field in a Spin-1 Spinor Bose-Einstein Condensate</subfield><subfield code=\"h\">[Elektronische Daten]</subfield><subfield code=\"c\">[Yusuke Aoki, Makoto Tsubota]</subfield></datafield><datafield tag=\"520\" ind1=\"3\" ind2=\" \"><subfield code=\"a\">We numerically study spin turbulence made by the oscillating magnetic field in a two-dimensional homogeneous spin-1 spinor Bose-Einstein condensate. We confine ourselves to the case of the ferromagnetic interaction, where the ground state is ferromagnetic. By the oscillating magnetic field along some direction makes the system unstable. At first, the spin density vector revolves in the plane perpendicular to the magnetic field, exciting long-wavelength modes. Secondly, appear some vector components along the magnetic field. Finally, the system becomes spin turbulence. In terms of the energy spectrum of the spin-dependent interaction energy, the peak appears first at low wave number region. Gradually, the peak shifts from low to high wave number region. Eventually, the spectrum exhibits the −7/3 power law. The −7/3 power law is confirmed by the scaling analysis using the hydrodynamic equation of the spinor Bose-Einstein condensate</subfield></datafield><datafield tag=\"540\" ind1=\" \" ind2=\" \"><subfield code=\"a\">Springer Science+Business Media New York, 2012</subfield></datafield><datafield tag=\"690\" ind1=\" \" ind2=\"7\"><subfield code=\"a\">Spinor Bose-Einstein condensate</subfield><subfield code=\"2\">nationallicence</subfield></datafield><datafield tag=\"690\" ind1=\" \" ind2=\"7\"><subfield code=\"a\">Turbulence</subfield><subfield code=\"2\">nationallicence</subfield></datafield><datafield tag=\"690\" ind1=\" \" ind2=\"7\"><subfield code=\"a\">Quantum gases</subfield><subfield code=\"2\">nationallicence</subfield></datafield><datafield tag=\"700\" ind1=\"1\" ind2=\" \"><subfield code=\"a\">Aoki</subfield><subfield code=\"D\">Yusuke</subfield><subfield code=\"u\">Department of Physics, Osaka City University, Sumiyoshi-ku, 558-8585, Osaka, Japan</subfield><subfield code=\"4\">aut</subfield></datafield><datafield tag=\"700\" ind1=\"1\" ind2=\" \"><subfield code=\"a\">Tsubota</subfield><subfield code=\"D\">Makoto</subfield><subfield code=\"u\">Department of Physics, Osaka City University, Sumiyoshi-ku, 558-8585, Osaka, Japan</subfield><subfield code=\"4\">aut</subfield></datafield><datafield tag=\"773\" ind1=\"0\" ind2=\" \"><subfield code=\"t\">Journal of Low Temperature Physics</subfield><subfield code=\"d\">Springer US; http://www.springer-ny.com</subfield><subfield code=\"g\">171/3-4(2013-05-01), 382-388</subfield><subfield code=\"x\">0022-2291</subfield><subfield code=\"q\">171:3-4&#60;382</subfield><subfield code=\"1\">2013</subfield><subfield code=\"2\">171</subfield><subfield code=\"o\">10909</subfield></datafield><datafield tag=\"856\" ind1=\"4\" ind2=\"0\"><subfield code=\"u\">https://doi.org/10.1007/s10909-012-0806-1</subfield><subfield code=\"q\">text/html</subfield><subfield code=\"z\">Onlinezugriff via DOI</subfield></datafield><datafield tag=\"908\" ind1=\" \" ind2=\" \"><subfield code=\"D\">1</subfield><subfield code=\"a\">research-article</subfield><subfield code=\"2\">jats</subfield></datafield><datafield tag=\"950\" ind1=\" \" ind2=\" \"><subfield code=\"B\">NATIONALLICENCE</subfield><subfield code=\"P\">856</subfield><subfield code=\"E\">40</subfield><subfield code=\"u\">https://doi.org/10.1007/s10909-012-0806-1</subfield><subfield code=\"q\">text/html</subfield><subfield code=\"z\">Onlinezugriff via DOI</subfield></datafield><datafield tag=\"950\" ind1=\" \" ind2=\" \"><subfield code=\"B\">NATIONALLICENCE</subfield><subfield code=\"P\">700</subfield><subfield code=\"E\">1-</subfield><subfield code=\"a\">Aoki</subfield><subfield code=\"D\">Yusuke</subfield><subfield code=\"u\">Department of Physics, Osaka City University, Sumiyoshi-ku, 558-8585, Osaka, Japan</subfield><subfield code=\"4\">aut</subfield></datafield><datafield tag=\"950\" ind1=\" \" ind2=\" \"><subfield code=\"B\">NATIONALLICENCE</subfield><subfield code=\"P\">700</subfield><subfield code=\"E\">1-</subfield><subfield code=\"a\">Tsubota</subfield><subfield code=\"D\">Makoto</subfield><subfield code=\"u\">Department of Physics, Osaka City University, Sumiyoshi-ku, 558-8585, Osaka, Japan</subfield><subfield code=\"4\">aut</subfield></datafield><datafield tag=\"950\" ind1=\" \" ind2=\" \"><subfield code=\"B\">NATIONALLICENCE</subfield><subfield code=\"P\">773</subfield><subfield code=\"E\">0-</subfield><subfield code=\"t\">Journal of Low Temperature Physics</subfield><subfield code=\"d\">Springer US; http://www.springer-ny.com</subfield><subfield code=\"g\">171/3-4(2013-05-01), 382-388</subfield><subfield code=\"x\">0022-2291</subfield><subfield code=\"q\">171:3-4&#60;382</subfield><subfield code=\"1\">2013</subfield><subfield code=\"2\">171</subfield><subfield code=\"o\">10909</subfield></datafield><datafield tag=\"900\" ind1=\" \" ind2=\"7\"><subfield code=\"a\">Metadata rights reserved</subfield><subfield code=\"b\">Springer special CC-BY-NC licence</subfield><subfield code=\"2\">nationallicence</subfield></datafield><datafield tag=\"898\" ind1=\" \" ind2=\" \"><subfield code=\"a\">BK010053</subfield><subfield code=\"b\">XK010053</subfield><subfield code=\"c\">XK010000</subfield></datafield><datafield tag=\"949\" ind1=\" \" ind2=\" \"><subfield code=\"B\">NATIONALLICENCE</subfield><subfield code=\"E\">springer-10.1007/s10909-012-0806-1</subfield><subfield code=\"F\">NATIONALLICENCE</subfield><subfield code=\"b\">NL-springer</subfield><subfield code=\"u\">https://doi.org/10.1007/s10909-012-0806-1</subfield></datafield></record>";
    }

}



