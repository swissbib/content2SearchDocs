#!/bin/bash



#
PROJECTDIR_DOCPROCESSING=/swissbib_index/solrDocumentProcessing/MarcToSolr

#ulimit -v unlimited

function marc2solrAndPost ()
{

    #nr=1
    for datei in ${inputpath}/*.xml
    do
        #actually the name convention I assume is only possible for initial loading
        outputsubdir=`basename ${datei} .format.xml`
        outputsubdirdetail=${outDirBase}/${outputsubdir}
        echo ${outputsubdirdetail}
        mkdir -p ${outputsubdirdetail}

        TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds
        echo "\n\nstart of processing ["`basename ${datei}`"] see logfiles for more details"${TIMESTAMP}"\n" >> ${logscriptflow}

        #DLOGDEDUPLICATION = true -> intensives logging eines jeden Aufrufs der deduplucation Methode
        #in marcxml2solrlog4j org.swissbib.documentprocessing.plugins.RemoveDuplicates auch auf INFO setzen!

        java -Xms2048m -Xmx2048m                        \
            -Dlog4j.configuration=marcxml2solrlog4j.xml \
            -DLOGDEDUPLICATION=false                    \
            -DINPUT.FILE=${datei}                       \
            -DCONF.ADDITIONAL.PROPS.FILE=${confFile}    \
            -DOUTPUT.DIR=${outputsubdirdetail}          \
            -DXPATH.DIR=${xsltPath}                     \
            -jar ${marc2Solrjar}


#        TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds
#        echo "\nstart posting to SOLR - see logfiles for more details"${TIMESTAMP}"\n" >> ${logscriptflow}


#        java -Xms1024m -Xmx1024m \
#            -Durl=${indexingMasterUrl} \
#             -jar ${postjar} $outputsubdirdetail/*.xml >> ${logSendToSolr}

#        rm -r $outputsubdirdetail
    #    nr=$(($nr+1))


    done


}




xsltPath=${PROJECTDIR_DOCPROCESSING}/xslt
inputpath=${PROJECTDIR_DOCPROCESSING}/data/inputfiles.nbead
confFile=${PROJECTDIR_DOCPROCESSING}/dist/config.properties
outDirBase=${PROJECTDIR_DOCPROCESSING}/data/outputfiles.nbead
postjar=${PROJECTDIR_DOCPROCESSING}/dist/post.jar
marc2Solrjar=${PROJECTDIR_DOCPROCESSING}/dist/xml2SearchEngineDoc.jar
logSendToSolr=${PROJECTDIR_DOCPROCESSING}/data/log/post2SOLR.log
logscriptflow=${PROJECTDIR_DOCPROCESSING}/data/log/sb_marc2solr_initialloading.log
indexingMasterUrl=http://sb-s6.swissbib.unibas.ch:8080/solr/update


TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds
echo "sb_marc2solr_initialloading.sh started: "${TIMESTAMP}"\n" >> ${logscriptflow}


marc2solrAndPost

TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds
echo "sb_marc2solr_initialloading.sh finished: "${TIMESTAMP}"\n" >> ${logscriptflow}
