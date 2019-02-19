package org.swissbib.documentprocessing.plugins;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

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
    private static LibadminGeoJson libadminGeoJson;
    private static Logger facetLibraryLogger;

    static {
        //so far I haven't defined this Logger in Log4J configuration
        CreateLibraryFacets.facetLibraryLogger = LoggerFactory.getLogger("facetLibraries");
    }

    @Override
    public void initPlugin(HashMap<String, String> configuration) {

        //todo
        //5) write Junit tests for it. Related to Jackson and tests compare
        //https://gitlab.com/swissbib/classic/kafka-cbs-consumer/tree/master/src/main/java/org/swissbib/kafka/consumer

        ObjectMapper mapper = new ObjectMapper();
        try {
            this.libadminGeoJson = mapper.readValue(new URL(configuration.get("LIBADMIN_DEFINITIONS")), LibadminGeoJson.class);
        } catch (Exception e) {
            CreateLibraryFacets.facetLibraryLogger.error(e.getMessage() + "\\r\\n" + e.getStackTrace());
        }
    }

    @Override
    public void finalizePlugIn() {
        //System.out.println("finalize!");
    }

    /**
     *
     * @param institutionCode
     * @return
     */
    public String[] getHierarchicalLibraryFacet(String institutionCode) {
        //System.out.print("received:" + institutionCode);
        String[] institutionCodeArray = institutionCode.split(",");
        List<String> hierarchyStrings = new ArrayList<String>();

        for (int i=0; i< institutionCodeArray.length; i++) {
            for (LibadminGeoJsonFeature feature : this.libadminGeoJson.getFeatures()) {
                if (feature.getProperties().getBib_code().equals(institutionCodeArray[i])) {
                    hierarchyStrings.add("0/" + feature.getProperties().getCanton() + "/");
                    hierarchyStrings.add("1/" + feature.getProperties().getCanton() + "/" + institutionCodeArray[i] + "/");
                }
            }
        }
        if (hierarchyStrings.size() == 0) hierarchyStrings.add("noMatchingInstitutionCodeFound");
        String[] stringArray = new String[hierarchyStrings.size()];
        hierarchyStrings.toArray(stringArray);
        //System.out.println("returning:" + Arrays.toString(stringArray));
        return stringArray;
    }

}

/**
 * the class definitions starting here are needed to represent he structure of the libadmin-json
 */

class LibadminGeoJson {
    private String type;
    public String getType() { return this.type; }
    public void setType(String type) { this.type = type; }
    private LibadminGeoJsonFeature[] features;
    public LibadminGeoJsonFeature[] getFeatures() { return this.features; }
    public void setFeatures(LibadminGeoJsonFeature[] features) { this.features = features; }
}

class LibadminGeoJsonFeature {
    private String type;
    public String getType() { return this.type; }
    public void setType(String type) { this.type = type; }
    private Properties properties;
    public Properties getProperties() { return this.properties; }
    public void setProperties(Properties properties) { this.properties = properties; }
    private Geometry geometry;
    public Geometry getGeometry() { return this.geometry; }
    public void setGeometry(Geometry geometry) { this.geometry = geometry; }
}

class Properties {
    private String bib_code;
    private String group_code;
    private Address address;
    private String canton;
    private Label label;
    private Url url;
    public String getBib_code() { return this.bib_code; }
    public void setBib_code(String bib_code) { this.bib_code = bib_code; }
    public String getGroup_code() { return this.group_code; }
    public void setGroup_code(String group_code) { this.group_code = group_code; }
    public Address getAddress() { return this.address; }
    public void setAddress(Address address) { this.address = address; }
    public String getCanton() { return this.canton; }
    public void setCanton(String canton) { this.canton = canton; }
    public Label getLabel() { return this.label; }
    public void setLabel(Label label) { this.label = label; }
    public Url getUrl() { return this.url; }
    public void setUrl(Url url) { this.url = url; }
}

class Address {
    private String address;
    public String getAddress() { return this.address; }
    public void setAddress(String address) { this.address = address; }
    private String zip;
    public String getZip() { return this.zip; }
    public void setZip(String zip) { this.zip = zip; }
    private String city;
    public String getCity() { return this.city; }
    public void setCity(String city) { this.city = city; }
}

class Label {
    private String de;
    public String getDe() { return this.de; }
    public void setDe(String de) { this.de = de; }
    private String fr;
    public String getFr() { return this.fr; }
    public void setFr(String fr) { this.fr = fr; }
    private String it;
    public String getIt() { return this.it; }
    public void setIt(String it) { this.it = it; }
    private String en;
    public String getEn() { return this.en; }
    public void setEn(String en) { this.en = en; }
}

class Url {
    private String de;
    public String getDe() { return this.de; }
    public void setDe(String de) { this.de = de; }
    private String fr;
    public String getFr() { return this.fr; }
    public void setFr(String fr) { this.fr = fr; }
    private String it;
    public String getIt() { return this.it; }
    public void setIt(String it) { this.it = it; }
    private String en;
    public String getEn() { return this.en; }
    public void setEn(String en) { this.en = en; }
}

class Geometry {
    private String type;
    public String getType() { return this.type; }
    public void setType(String type) { this.type = type; }
    private float[] coordinates;
    public float[] getCoordinates() { return this.coordinates; }
    public void setCoordinates(float[] coordinates) { this.coordinates = coordinates; }
}
