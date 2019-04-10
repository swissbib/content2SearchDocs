package org.swissbib.documentprocessing.plugins;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.FileInputStream;
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
 * @author Matthias Edel   <matthias.edel@unibas.ch>
 * @link http://www.swissbib.org
 * @link https://github.com/swissbib/content2SearchDocs
 */

public class CreateLibraryFacets implements IDocProcPlugin {
    private static LibadminGeoJson libadminGeoJson;
    private static Logger facetLibraryLogger;
    private static boolean initSucceeded = false;

    static {
        CreateLibraryFacets.facetLibraryLogger = LoggerFactory.getLogger("facetLibraries");
    }

    @Override
    public void initPlugin(HashMap<String, String> configuration) {

        //todo
        //5) write Junit tests for it. Related to Jackson and tests compare
        //https://gitlab.com/swissbib/classic/kafka-cbs-consumer/tree/master/src/main/java/org/swissbib/kafka/consumer

        ObjectMapper mapper = new ObjectMapper();
        try {
            // get libadminGeoJson from local file (synced by nightly cronjob)
            libadminGeoJson = mapper.readValue(new FileInputStream(configuration.get("LIBADMIN_DEFINITIONS")), LibadminGeoJson.class);
            initSucceeded = true;
        } catch (Exception e) {
            initSucceeded = false;
            CreateLibraryFacets.facetLibraryLogger.warn(e.getMessage() + "\\r\\n" + e);
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
        List<String> hierarchyStrings = new ArrayList<String>();
        if (initSucceeded) {
            String[] institutionCodeArray = institutionCode.split(",");
            String e0, e1;
            for (int i = 0; i < institutionCodeArray.length; i++) {
                for (Institution institution : libadminGeoJson.getInstitutions()) {
                    if (institution.getBib_code().equals(institutionCodeArray[i])
                            && !institution.getCanton().isEmpty()) {
                        e0 = "0/" + institution.getCanton() + "/";
                        e1 = "1/" + institution.getCanton() + "/" + institutionCodeArray[i] + "/";
                        if (!hierarchyStrings.contains(e0)) {
                            hierarchyStrings.add(e0);
                        }
                        if (!hierarchyStrings.contains(e1)) {
                            hierarchyStrings.add(e1);
                        }
                    }
                }
            }
        }
        if (hierarchyStrings.size() == 0) hierarchyStrings.add("");
        String[] stringArray = new String[hierarchyStrings.size()];
        stringArray = hierarchyStrings.toArray(stringArray);
        return stringArray;
    }

}

/**
 * the class definitions starting here are needed to represent he structure of the libadmin-json
 */

class LibadminGeoJson {
    private Institution[] institutions;
    public Institution[] getInstitutions() { return this.institutions; }
    public void setInstitutions(Institution[] institutions) { this.institutions = institutions; }
}

class Institution {
    private String bib_code;
    public String getBib_code() { return this.bib_code; }
    public void setBib_code(String bib_code) { this.bib_code = bib_code; }
    private String canton;
    public String getCanton() { return this.canton; }
    public void setCanton(String canton) { this.canton = canton; }
    private String group_code;
    public String getGroup_code() { return this.group_code; }
    public void setGroup_code(String group_code) { this.group_code = group_code; }
    private Label label;
    public Label getLabel() { return this.label; }
    public void setLabel(Label label) { this.label = label; }
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
