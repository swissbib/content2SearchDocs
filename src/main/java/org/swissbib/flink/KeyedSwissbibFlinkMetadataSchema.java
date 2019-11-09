package org.swissbib.flink;

import org.apache.flink.api.common.serialization.DeserializationSchema;
import org.apache.flink.api.common.serialization.SerializationSchema;
import org.apache.flink.api.common.typeinfo.TypeInformation;
import org.apache.flink.api.java.typeutils.TypeExtractor;
import org.apache.flink.streaming.connectors.kafka.KafkaDeserializationSchema;
import org.apache.flink.streaming.util.serialization.KeyedSerializationSchema;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.swissbib.SbMetadataModel;

import java.io.UnsupportedEncodingException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class KeyedSwissbibFlinkMetadataSchema implements
        KeyedSerializationSchema<SbMetadataModel>, KafkaDeserializationSchema<SbMetadataModel> {

    //<field name="id">131051466</field>
    private Pattern idPattern = Pattern.compile(".*?<field name=\"id\">(.*?)</field>.*",Pattern.CASE_INSENSITIVE|Pattern.DOTALL);


    @Override
    public boolean isEndOfStream(SbMetadataModel nextElement) {
        return false;
    }

    @Override
    public SbMetadataModel deserialize(ConsumerRecord<byte[], byte[]> record) throws Exception {
        //String key =  new String(record.key());
        //String body = new String(record.);
        SbMetadataModel fm = new SbMetadataModel();
        fm.fromByteArray(record.value(),"UTF8");
        return fm;
    }


    @Override
    public TypeInformation<SbMetadataModel> getProducedType() {
        return TypeExtractor.getForClass(SbMetadataModel.class);
    }

    @Override
    public byte[] serializeKey(SbMetadataModel element) {
        //String test = element.getData();
        Matcher m = idPattern.matcher(element.getData());
        String id = null;
        if (m.matches()) {
            return m.group(1).getBytes();
        } else {
            //to throw exception
            return new byte[0];
        }

    }

    @Override
    public byte[] serializeValue(SbMetadataModel element) {

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
    public String getTargetTopic(SbMetadataModel element)
    {
        return "sb-solr";
    }
}
