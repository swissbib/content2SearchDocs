package org.swissbib.metafacture.xml.xslt.plugins;

import org.swissbib.metafacture.xml.xslt.helper.PipeConfig;

import java.util.Arrays;
import java.util.HashSet;



public class RemoveDuplicates implements IXSLTPlugin{



    public String removeDuplicatesFromMultiValuedField(String inputValues) {


        String[] splittedValues =   inputValues.split("##xx##");
        HashSet<String> uniqueSet = new HashSet<String>();
        uniqueSet.addAll(Arrays.asList(splittedValues));

        //System.out.println(uniqueSet.size());

        StringBuilder uniqueValues = new StringBuilder();

        int i = 1;
        int sizeOfSet = uniqueSet.size();
        for (String uniquevalue : uniqueSet) {
            uniqueValues.append(uniquevalue);
            if (i < sizeOfSet) {
                uniqueValues.append("##xx##");
            }
            i++;
        }


        return uniqueValues.toString();
    }

    @Override
    public void initPlugin(PipeConfig configuration) {
        //To change body of implemented methods use File | Settings | File Templates.
    }

    @Override
    public void finalizePlugIn() {
        //To change body of implemented methods use File | Settings | File Templates.
    }

}
