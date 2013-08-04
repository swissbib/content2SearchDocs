#!/bin/bash



#variables for holdings processing (update and delete)
CURRENT_TIMESTAMP=`date +%Y%m%d%H%M%S`
PROJECTDIR_DOCPROCESSING=/swissbib_index/solrDocumentProcessing

#ulimit -v unlimited


function setTimestamp()
{
    CURRENT_TIMESTAMP=`date +%Y%m%d%H%M%S`
}



function viaf2solr ()
{

    #nr=1
    for datei in ${inputpath}/*.m21
    do
        #actually the name convention I assume is only possible for initial loading
        outputsubdir=`basename ${datei} .m21`
        outputsubdirdetail=${outDirBase}/${outputsubdir}
        printf  ${outputsubdirdetail} >> ${logscriptflow}
        mkdir -p ${outputsubdirdetail}

        setTimestamp
        printf "\n\nstart of processing ["`basename ${datei}`"] see logfiles for more details <<%s>>\n"${CURRENT_TIMESTAMP} >> ${logscriptflow}

        #DLOGDEDUPLICATION = true -> intensives logging eines jeden Aufrufs der deduplucation Methode
        #in marcxml2solrlog4j org.swissbib.documentprocessing.plugins.RemoveDuplicates auch auf INFO setzen!

        java -Xms2048m -Xmx2048m  \
            -Dlog4j.configuration=marcxml2solrlog4j.xml \
            -jar ${viaf2Solrjar}    \
            --input=${datei}    \
            --conf=${confFile}  \
            --outputdir=${outputsubdirdetail}   \
            --xpath=${xsltPath}


#        TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds
#        echo "\nstart posting to SOLR - see logfiles for more details"${CURRENT_TIMESTAMP}"\n" >> ${logscriptflow}


#        java -Xms1024m -Xmx1024m \
#            -Durl=${indexingMasterUrl} \
#             -jar ${postjar} $outputsubdirdetail/*.xml >> ${logSendToSolr}

#        rm -r $outputsubdirdetail
    #    nr=$(($nr+1))


    done


}




xsltPath=${PROJECTDIR_DOCPROCESSING}/MarcToSolr/xsltViaf
inputpath=${PROJECTDIR_DOCPROCESSING}/VIAF/inputfiles
confFile=${PROJECTDIR_DOCPROCESSING}/MarcToSolr/dist/configViaf.properties
outDirBase=${PROJECTDIR_DOCPROCESSING}/MarcToSolr/data/outputfilesViaf
viaf2Solrjar=${PROJECTDIR_DOCPROCESSING}/MarcToSolr/dist/viaf2solr.processing.jar
logscriptflow=${PROJECTDIR_DOCPROCESSING}/MarcToSolr/data/log/sb_viaf2solr_procedure_loading.log


setTimestamp
printf "sb_marc2solr_initialloading.sh started: <<%s>>....\n"${CURRENT_TIMESTAMP} >> ${logscriptflow}


viaf2solr

setTimestamp
printf  "sb_marc2solr_initialloading.sh finished: <<%s>>...\n"${CURRENT_TIMESTAMP} >> ${logscriptflow}
