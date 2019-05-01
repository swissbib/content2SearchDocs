package org.swissbib.flink;

import org.apache.flink.api.common.functions.RichMapFunction;
import org.apache.flink.configuration.Configuration;
//import org.swissbib.SbMetadataModel;
import org.swissbib.documentprocessing.MFXsltBasedBridge;
import org.swissbib.types.CbsActions;

public class DocProcFunction extends RichMapFunction<FlinkSbMetadaModel,FlinkSbMetadaModel> {


    MFXsltBasedBridge bridge2pipe;

    @Override
    public FlinkSbMetadaModel map(FlinkSbMetadaModel record) throws Exception {

        //todo make transformations
        String test = record.getData();

        String response = bridge2pipe.transform(test);
        FlinkSbMetadaModel sbm = new FlinkSbMetadaModel();
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
