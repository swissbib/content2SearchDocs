#!/bin/bash

#ulimit -v unlimited

function marc2solrAndPost ()
{
    #nr=1
    for datei in ${inputpath}/*.gz
    do
        #actually the name convention I assume is only possible for initial loading

        echo "unzip $datei" >> ${logscriptflow}
        gunzip ${datei}

        outputsubdir=`basename ${datei} .format.xml.gz`
        outputsubdirdetail=${outDirBase}/${outputsubdir}

        echo "subdirectory for search engine documents:   ${outputsubdirdetail}"  >> ${logscriptflow}
        mkdir -p ${outputsubdirdetail}

        TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds
        echo "\n\nstart of processing ["`basename ${datei}`"] see logfiles for more details"${TIMESTAMP}"\n" >> ${logscriptflow}

        #DLOGDEDUPLICATION = true -> intensives logging eines jeden Aufrufs der deduplucation Methode
        #in marcxml2solrlog4j org.swissbib.documentprocessing.plugins.RemoveDuplicates auch auf INFO setzen!

        java -Xms2048m -Xmx2048m                        \
            -Dlog4j.configuration=marcxml2solrlog4j_2.xml \
            -DLOGDEDUPLICATION=false                    \
            -DINPUT.FILE=${datei/.gz/}                  \
            -DCONF.ADDITIONAL.PROPS.FILE=${confFile}    \
            -DOUTPUT.DIR=${outputsubdirdetail}          \
            -DXPATH.DIR=${xsltPath}                     \
            -DTARGET.SEARCHENGINE=org.swissbib.documentprocessing.solr.XML2SOLRDocEngine  \
            -DSKIPRECORDS=false                         \
            -jar ${marc2Solrjar}

#        TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds
#        echo "\nstart posting to SOLR - see logfiles for more details"${TIMESTAMP}"\n" >> ${logscriptflow}
#        java -Xms1024m -Xmx1024m \
#            -Durl=${indexingMasterUrl} \
#             -jar ${postjar} $outputsubdirdetail/*.xml >> ${logSendToSolr}
#        rm -r $outputsubdirdetail
    #    nr=$(($nr+1))

        echo "now all the created files conatining search engine docs will be zipped " >> ${logscriptflow}
        gzip ${outputsubdirdetail}/*.xml

        echo "now gzip the inputfile again" >> ${logscriptflow}
        gzip  ${datei/.gz/}

    done

}

# path definitions
PROJECTDIR_DOCPROCESSING=/swissbib_index/solrDocumentProcessing/MarcToSolr

PROJECTDIR_FREQUENT=/swissbib_index/solrDocumentProcessing/FrequentInitialPreProcessing

xsltPath=${PROJECTDIR_DOCPROCESSING}/xslt###${PROJECTDIR_DOCPROCESSING}/xsltskipRecords

inputpath=${PROJECTDIR_FREQUENT}/data/format_2

confFile=${PROJECTDIR_DOCPROCESSING}/dist/config.properties

outDirBase=${PROJECTDIR_DOCPROCESSING}/data/outputfiles

postjar=${PROJECTDIR_DOCPROCESSING}/dist/post.jar
marc2Solrjar=${PROJECTDIR_DOCPROCESSING}/dist/content2SearchDocs-0.8-SNAPSHOT.jar
logSendToSolr=${PROJECTDIR_DOCPROCESSING}/data/log/post2SOLR_2.log
logscriptflow=${PROJECTDIR_DOCPROCESSING}/data/log/sb_marc2solr_initialloading_2.log
#indexingMasterUrl=[undefined at the moment]

# definitions and function call
TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds
echo "sb_marc2solr_initialloading.sh started: "${TIMESTAMP}"\n" >> ${logscriptflow}

marc2solrAndPost

TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds
echo "sb_marc2solr_initialloading.sh finished: "${TIMESTAMP}"\n" >> ${logscriptflow}
