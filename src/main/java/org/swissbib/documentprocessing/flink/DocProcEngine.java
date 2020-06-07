package org.swissbib.documentprocessing.flink;

import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import org.apache.flink.api.common.typeinfo.Types;
import org.apache.flink.api.java.utils.ParameterTool;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaConsumer;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaProducer;
import org.swissbib.SbMetadataModel;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.UUID;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.swissbib.documentprocessing.flink.functions.MapDataObject2DataObjectFunction;
import org.swissbib.documentprocessing.flink.functions.MapDataObject2MetadaModelFunction;
import org.swissbib.documentprocessing.flink.functions.MapStartFunction;
import org.swissbib.documentprocessing.flink.helper.PipeConfig;


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

        String configFile = ParameterTool.fromArgs(args).get("config","pipeDefaultConfig.yaml");
        PipeConfig config = readConfig(configFile);

        //final ExecutionEnvironment env = ExecutionEnvironment.createLocalEnvironment(1);
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        //ParameterTool parameters = ParameterTool.fromPropertiesFile("data/config.us-13.properties");
        //env.getConfig().setGlobalJobParameters(parameters);

        Properties properties = createKafkaProperties(config);


        FlinkKafkaConsumer<SbMetadataModel> fc = new FlinkKafkaConsumer<SbMetadataModel>(
                getSourceTopic(config),    new KeyedSwissbibFlinkMetadataSchema(),    properties);
        fc.setStartFromGroupOffsets();



        FlinkKafkaProducer<SbMetadataModel> kafkaProducer = new FlinkKafkaProducer<SbMetadataModel>(
                getSinkTopic(config), new KeyedSwissbibFlinkMetadataSchema() ,
                properties,FlinkKafkaProducer.Semantic.AT_LEAST_ONCE);

        DataStream<SbMetadataModel> stream = env.addSource(fc).returns(Types.GENERIC(SbMetadataModel.class));

        stream.map(new MapStartFunction(config))
            .map(new MapDataObject2DataObjectFunction(config,"0"))
                .map(new MapDataObject2DataObjectFunction(config,"1"))
                .map(new MapDataObject2DataObjectFunction(config,"2"))
                .map(new MapDataObject2DataObjectFunction(config, "3", true,true))
                /*
                the default max size of message.max.bytes is 1000000
                otherwise we get such error messages
                Caused by: org.apache.flink.streaming.connectors.kafka.FlinkKafkaException: Failed to send data to Kafka: The message is 1620459 bytes when serialized which is larger than the maximum request size you have configured with the max.request.size configuration.
                https://kafka.apache.org/081/documentation.html
                give a little bit more space for the object to be serialized
                The maximum size of a message that the server can receive. It is important that this property be in sync with the maximum fetch size your consumers use or else an unruly producer will be able to publish messages too large for consumers to consume.
                => we have to sync producers and consumers for such topics
                 */
                .filter(xsltDataObject -> xsltDataObject.record.getBytes().length <= 990000)
                .map(new MapDataObject2MetadaModelFunction(config)).returns(Types.GENERIC(SbMetadataModel.class))

            .addSink(kafkaProducer);

        env.setParallelism(1);
        env.execute("swissbib classic goes BigData");

    }



    private static PipeConfig readConfig(String configFileName) {

            ClassLoader classLoader = DocProcEngine.class.getClassLoader();
            PipeConfig config = null;
            try (InputStream is =  classLoader.getResourceAsStream(configFileName)) {
                ObjectMapper mapper = new ObjectMapper(new YAMLFactory());
                config = mapper.readValue(is, PipeConfig.class);
            } catch (IOException ioexc) {
                throw new RuntimeException(ioexc);
            }
            return config;

    }

    private static Properties createKafkaProperties(PipeConfig config) {

        Properties properties = new Properties();
        //properties.setProperty("bootstrap.servers", "localhost:9092,localhost:9093,localhost:9094");
        //properties.setProperty("bootstrap.servers", "sb-uka3:9092,sb-uka4:9092,sb-uka5:9092,sb-uka6:9092");
        properties.setProperty("bootstrap.servers", config.getKafka().getOrDefault("bootstrap.servers",
                "localhost:9092,localhost:9093,localhost:9094"));
        properties.setProperty("group.id", config.getKafka().
                getOrDefault("group.id",UUID.randomUUID().toString()));
        if (config.getKafka().containsKey("auto.offset.reset")) {
            properties.setProperty("auto.offset.reset",config.getKafka().get("auto.offset.reset"));
        properties.setProperty("message.max.bytes", "" + 1024 * 1024 * 5);
        }
        //properties.setProperty("auto.offset.reset",config.getKafka().getOrDefault("auto.offset.reset",
        //        "earliest"));

        return properties;

    }

    private static String getSourceTopic(PipeConfig config) {
        return config.getKafka().getOrDefault("topicSource",
                "sb-all");
    }

    private static String getSinkTopic(PipeConfig config) {
        return config.getKafka().getOrDefault("topicSink",
                "sb-solr");
    }


}
