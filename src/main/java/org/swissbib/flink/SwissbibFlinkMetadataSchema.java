package org.swissbib.flink;

import org.apache.flink.api.common.serialization.DeserializationSchema;
import org.apache.flink.api.common.serialization.SerializationSchema;
import org.apache.flink.api.common.typeinfo.TypeInformation;
import org.apache.flink.api.java.typeutils.TypeExtractor;
import org.swissbib.SbMetadataModel;

import java.io.IOException;

public class SwissbibFlinkMetadataSchema implements
        DeserializationSchema<FlinkSbMetadaModel>, SerializationSchema<FlinkSbMetadaModel> {


    @Override
    public FlinkSbMetadaModel deserialize(byte[] message) throws IOException {
        FlinkSbMetadaModel test = new FlinkSbMetadaModel().fromByteArray(message, "UTF8");
        return test;
    }

    @Override
    public boolean isEndOfStream(FlinkSbMetadaModel nextElement) {
        return false;
    }

    @Override
    public byte[] serialize(FlinkSbMetadaModel element) {
        return new byte[0];
    }

    @Override
    public TypeInformation<FlinkSbMetadaModel> getProducedType() {
        return TypeExtractor.getForClass(FlinkSbMetadaModel.class);
    }
}
