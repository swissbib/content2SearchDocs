package org.swissbib.documentprocessing.flink.functions;

import org.apache.flink.api.common.functions.RichMapFunction;
import org.apache.flink.configuration.Configuration;
import org.swissbib.SbMetadataModel;
import org.swissbib.documentprocessing.flink.helper.PipeConfig;
import org.swissbib.documentprocessing.flink.helper.XSLTDataObject;
import org.swissbib.types.CbsActions;

public class MapDataObject2MetadaModelFunction extends RichMapFunction<XSLTDataObject, SbMetadataModel> {

    private PipeConfig pipeConfig;

    public MapDataObject2MetadaModelFunction(PipeConfig pipeConfig) {
        this.pipeConfig = pipeConfig;
    }

    @Override
    public SbMetadataModel map(XSLTDataObject value) throws Exception {

        SbMetadataModel sbmdm = new SbMetadataModel();
        sbmdm.setData(value.record);
        //holdingsStructure
        sbmdm.setCbsAction(CbsActions.CREATE);

        return sbmdm;
    }

    @Override
    public void open(Configuration parameters) throws Exception {
        super.open(parameters);
    }

    @Override
    public void close() throws Exception {
        super.close();
    }


}
