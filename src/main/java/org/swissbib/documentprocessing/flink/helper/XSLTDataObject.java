package org.swissbib.documentprocessing.flink.helper;

import java.io.Serializable;
import java.util.HashMap;

/**
 * Created by swissbib on 29.05.17.
 */
public class XSLTDataObject  {

    public HashMap<String,String> additions = new HashMap<>();

    public String record = "";


    @Override
    public String toString() {
        return record;
    }
}
