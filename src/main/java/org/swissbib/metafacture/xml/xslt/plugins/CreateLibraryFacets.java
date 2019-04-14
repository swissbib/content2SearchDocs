package org.swissbib.metafacture.xml.xslt.plugins;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.swissbib.metafacture.xml.xslt.helper.PipeConfig;

import java.io.FileInputStream;
import java.util.ArrayList;
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

public class CreateLibraryFacets implements IXSLTPlugin {


    @Override
    public void initPlugin(PipeConfig configuration) {

    }

    @Override
    public void finalizePlugIn() {
        //System.out.println("finalize!");
    }

    public String[] getHierarchicalLibraryFacet(String institutionCode) {

        return new String[] {"123"};

    }

}

