#!/bin/bash

# sb_marc2solr_archivaldata.sh
# ****************************************
# Description: Script controls the transformation of MARC21 data of archival collections (HelveticArchives, HAN)
#              into search engine documents for swissbib solr indexes
#              Collections concerned are not updated through frequent and automatic procedures but treated completely.
#              For re-indexing, delete all records first from index
#
# Authors: Günter Hipler (ghi), Oliver Schihin (osc)
#
# History
# xx.xx.2015 : ghi : Creation
# 20.08.2015 : osc : Name change, adaptions for generic archival data imports
#
# Generic path definitions
PROJECTDIR_DOCPROCESSING=/swissbib_index/solrDocumentProcessing/MarcToSolr
PROJECTDIR_FREQUENT=/swissbib_index/solrDocumentProcessing/FrequentInitialPreProcessing

# specific variables and path definitions
xsltPath=${PROJECTDIR_DOCPROCESSING}/xslt
inputpath=${PROJECTDIR_FREQUENT}/data/format_archivaldata
confFile=${PROJECTDIR_DOCPROCESSING}/dist/configArchivaldata.properties
outDirBase=${PROJECTDIR_DOCPROCESSING}/data/outputfiles_archivaldata
postjar=${PROJECTDIR_DOCPROCESSING}/dist/post.jar
marc2Solrjar=${PROJECTDIR_DOCPROCESSING}/dist/xml2SearchEngineDoc.jar
logSendToSolr=${PROJECTDIR_DOCPROCESSING}/data/log/post2SOLR.log
logscriptflow=${PROJECTDIR_DOCPROCESSING}/data/log/sb_marc2solr_archivaldata.log

#ulimit -v unlimited

# function to call transforming scripts
function marc2solr ()
{
    #nr=1
    for datei in ${inputpath}/*.xml
    do
        outputsubdir=`basename ${datei} .format.xml`
        outputsubdirdetail=${outDirBase}/${outputsubdir}
        echo ${outputsubdirdetail}
        mkdir -p ${outputsubdirdetail}

        TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds
        echo "\n\nstart of processing ["`basename ${datei}`"]. See logfiles for more details"${TIMESTAMP}"\n" >> ${logscriptflow}

        #DLOGDEDUPLICATION = true -> intensives logging eines jeden Aufrufs der deduplucation Methode
        #in marcxml2solrlog4j org.swissbib.documentprocessing.plugins.RemoveDuplicates auch auf INFO setzen!

        java -Xms2048m -Xmx2048m                           \
             -Dlog4j.configuration=marcxml2solrlog4j_1.xml \
             -DLOGDEDUPLICATION=false                      \
             -DINPUT.FILE=${datei}                   \
             -DCONF.ADDITIONAL.PROPS.FILE=${confFile}      \
             -DOUTPUT.DIR=${outputsubdirdetail}            \
             -DXPATH.DIR=${xsltPath}                       \
             -DTARGET.SEARCHENGINE=org.swissbib.documentprocessing.solr.XML2SOLRDocEngine  \
             -DSKIPRECORDS=false                           \
             -jar ${marc2Solrjar}
    done
}

# log start
TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds
echo "sb_marc2solr_archivaldata.sh started: "${TIMESTAMP}"\n" >> ${logscriptflow}

# call function
marc2solr

# log end
TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds
echo "sb_marc2solr_archivaldata.sh finished: "${TIMESTAMP}"\n" >> ${logscriptflow}
