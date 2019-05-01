package org.swissbib.flink;

import org.apache.flink.api.common.functions.RichMapFunction;
import org.apache.flink.api.common.serialization.SimpleStringSchema;
//import org.apache.flink.api.java.ExecutionEnvironment;
//import org.apache.flink.api.java.operators.DataSource;
//import org.apache.flink.api.java.operators.DataSource;
//import org.apache.flink.api.java.utils.ParameterTool;
import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.api.java.operators.DataSource;
import org.apache.flink.configuration.Configuration;
import org.apache.flink.core.fs.FileSystem;
//import org.apache.flink.streaming.api.datastream.DataStream;
//import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaConsumer;
import org.swissbib.documentprocessing.MFXsltBasedBridge;

import java.util.Properties;


/**
 * Created by swissbib on 08.05.17.
 */
public class DocProcEngine {

    public static void main (String[] args) throws Exception {

        //final ExecutionEnvironment env = ExecutionEnvironment.createLocalEnvironment(1);
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        //ParameterTool parameters = ParameterTool.fromPropertiesFile("data/config.us-13.properties");
        //env.getConfig().setGlobalJobParameters(parameters);
        Properties properties = new Properties();
        properties.setProperty("bootstrap.servers", "localhost:9092,localhost:9093,localhost:9094");
        properties.setProperty("group.id", "test2");
        properties.setProperty("auto.offset.reset", "earliest");
        DataStream<FlinkSbMetadaModel> stream = env.addSource(  new FlinkKafkaConsumer<FlinkSbMetadaModel>(    "sb-all",    new SwissbibFlinkMetadataSchema(),    properties));
        //DataSource<String> docProcRecords = env.readTextFile("/swissbib_index/rawData/marcDataCBS/MFconform/job2r9A151.format.nocollection.xml");

        //docProcRecords.map(new SolrDocProcFunction()).withParameters(parameters.getConfiguration())
        //        .writeAsText("dataout/output.txt", FileSystem.WriteMode.OVERWRITE);
        //docProcRecords.map(new SolrDocProcFunction())
        //        .writeAsText("output.txt", FileSystem.WriteMode.OVERWRITE);
        stream.map(new SolrDocProcFunction())
                .writeAsText("output.txt", FileSystem.WriteMode.OVERWRITE);

        env.setParallelism(1);


        env.execute("swissbib classic goes BigData");


    }



    public static class SolrDocProcFunction extends RichMapFunction<FlinkSbMetadaModel, String> {

        MFXsltBasedBridge bridge2pipe;

        @Override
        public String map(FlinkSbMetadaModel record) throws Exception {

            //todo make transformations
            String test = record.getData();

            String response = bridge2pipe.transform(test);
            return response;

        }

        @Override
        public void open(Configuration parameters) throws Exception {
            super.open(parameters);

            //bridge2pipe = MFXsltBasedBridge.build().
            //        setConfigFileName("pipeDefaultConfig.yaml");
            bridge2pipe = new MFXsltBasedBridge("pipeDefaultConfig.yaml");


            bridge2pipe.init();

        }



    }


}
