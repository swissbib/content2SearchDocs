package org.swissbib.flink;

import org.apache.flink.api.common.serialization.DeserializationSchema;
import org.apache.flink.api.common.serialization.SerializationSchema;
import org.apache.flink.api.common.typeinfo.TypeInformation;
import org.apache.flink.api.java.typeutils.TypeExtractor;
import org.swissbib.SbMetadataModel;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

public class SwissbibFlinkMetadataSchema implements
        DeserializationSchema<FlinkSbMetadaModel>, SerializationSchema<FlinkSbMetadaModel> {


    @Override
    public FlinkSbMetadaModel deserialize(byte[] message) throws IOException {
        return new FlinkSbMetadaModel().fromByteArray(message, "UTF8");
    }

    @Override
    public boolean isEndOfStream(FlinkSbMetadaModel nextElement) {
        return false;
    }

    @Override
    public byte[] serialize(FlinkSbMetadaModel element) {

        byte [] b;
        try {
            b = element.toByteArray("UTF8");
        } catch (UnsupportedEncodingException unsupportedEncoding) {
            //todo handle Exception and provide something meaningful;
            unsupportedEncoding.printStackTrace();
            b = new byte[0];
        }
        return b;
    }

    @Override
    public TypeInformation<FlinkSbMetadaModel> getProducedType() {
        return TypeExtractor.getForClass(FlinkSbMetadaModel.class);
    }
}
