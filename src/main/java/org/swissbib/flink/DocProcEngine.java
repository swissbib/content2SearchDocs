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
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaProducer;
import org.swissbib.SbMetadataModel;
import org.swissbib.documentprocessing.MFXsltBasedBridge;

import java.util.Properties;
import java.util.UUID;


/**
 * Created by swissbib on 08.05.17.
 */
public class DocProcEngine {



    //ssl config: https://ci.apache.org/projects/flink/flink-docs-release-1.8/ops/security-ssl.html
    //https://github.com/GezimSejdiu/flink-starter
    //https://de.slideshare.net/sbaltagi/apache-flinkcrashcoursebyslimbaltagiandsrinipalthepu?next_slideshow=1
    //https://de.slideshare.net/sbaltagi/stepbystep-introduction-to-apache-flink

    //https://www.ververica.com/blog/how-apache-flink-manages-kafka-consumer-offsets


    public static void main (String[] args) throws Exception {

        //final ExecutionEnvironment env = ExecutionEnvironment.createLocalEnvironment(1);
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        //ParameterTool parameters = ParameterTool.fromPropertiesFile("data/config.us-13.properties");
        //env.getConfig().setGlobalJobParameters(parameters);
        Properties properties = new Properties();
        //properties.setProperty("bootstrap.servers", "localhost:9092,localhost:9093,localhost:9094");
        properties.setProperty("bootstrap.servers", "sb-uka3:9092,sb-uka4:9092,sb-uka5:9092,sb-uka6:9092");
        properties.setProperty("group.id", UUID.randomUUID().toString());
        //properties.setProperty("auto.offset.reset", "earliest");


        FlinkKafkaConsumer<SbMetadataModel> fc = new FlinkKafkaConsumer<SbMetadataModel>(    "sb-all",    new KeyedSwissbibFlinkMetadataSchema(),    properties);
        fc.setStartFromGroupOffsets();


        FlinkKafkaProducer<SbMetadataModel> kafkaProducer = new FlinkKafkaProducer<SbMetadataModel>("sb-solr", new KeyedSwissbibFlinkMetadataSchema() ,properties);



        DataStream<SbMetadataModel> stream = env.addSource(fc);
        //DataSource<String> docProcRecords = env.readTextFile("/swissbib_index/rawData/marcDataCBS/MFconform/job2r9A151.format.nocollection.xml");

        //docProcRecords.map(new SolrDocProcFunction()).withParameters(parameters.getConfiguration())
        //        .writeAsText("dataout/output.txt", FileSystem.WriteMode.OVERWRITE);
        //docProcRecords.map(new SolrDocProcFunction())
        //        .writeAsText("output.txt", FileSystem.WriteMode.OVERWRITE);
        stream.map(new DocProcFunction())
               // .writeAsText("outputdir", FileSystem.WriteMode.OVERWRITE);
            .addSink(kafkaProducer);

        env.setParallelism(1);


        env.execute("swissbib classic goes BigData");


    }



    public static class SolrDocProcFunction extends RichMapFunction<FlinkSbMetadaModel, String> {

        MFXsltBasedBridge bridge2pipe;

        @Override
        public String map(FlinkSbMetadaModel record) throws Exception {

            return bridge2pipe.transform(record.getData());

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
