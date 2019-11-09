package org.swissbib.flink;

import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.api.common.functions.RichMapFunction;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaConsumer;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaProducer;
import org.apache.flink.table.api.Table;
import org.apache.flink.table.api.java.StreamTableEnvironment;
import org.swissbib.SbMetadataModel;

import java.util.Properties;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class TestReadKafka {

    static Table result;

    public static void main (String[] args)  throws Exception {


        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        StreamTableEnvironment tEnv = StreamTableEnvironment.create(env);

        Properties properties = new Properties();
        properties.setProperty("bootstrap.servers", "localhost:9092,localhost:9093,localhost:9094");
        properties.setProperty("group.id", "1");
        properties.setProperty("auto.offset.reset", "earliest");


        FlinkKafkaConsumer<SbMetadataModel> fc = new FlinkKafkaConsumer<SbMetadataModel>("sb-all", new KeyedSwissbibFlinkMetadataSchema(), properties);
        fc.setStartFromEarliest();

        DataStream<SbMetadataModel> stream = env.addSource(fc);
        DataStream<String> teststream = stream.map(new TestMap());

        Table tableA = tEnv.fromDataStream(teststream);

        result = tEnv.sqlQuery("SELECT count(*) FROM " + tableA);

        tEnv.toRetractStream(result, Long.class).print();



        //teststream.print();

        env.execute("Test Read Kafka");

    }


        public static class TestMap implements MapFunction<SbMetadataModel,String> {


            Pattern p = Pattern.compile(".*?<controlfield tag=\"001\">(.*?)</controlfield>.*");

            @Override
            public String map(SbMetadataModel value) throws Exception {

                Matcher m = p.matcher(value.getData());

                return m.matches() ? m.group(1) : "n/a";
            }
        }


}
