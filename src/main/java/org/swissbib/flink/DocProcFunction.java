package org.swissbib.flink;

import org.apache.flink.api.common.functions.RichMapFunction;
import org.apache.flink.configuration.Configuration;
//import org.swissbib.SbMetadataModel;
import org.swissbib.SbMetadataDeserializer;
import org.swissbib.SbMetadataModel;
import org.swissbib.documentprocessing.MFXsltBasedBridge;
import org.swissbib.types.CbsActions;

public class DocProcFunction extends RichMapFunction<SbMetadataModel,SbMetadataModel> {


    MFXsltBasedBridge bridge2pipe;

    @Override
    public SbMetadataModel map(SbMetadataModel record) throws Exception {


        String response = bridge2pipe.transform(record.getData());
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
}
