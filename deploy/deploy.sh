#!/bin/sh

SOLR_DOC_BASE=/swissbib_index/solrDocumentProcessing
SOLR_DOC_MARC=${SOLR_DOC_BASE}/MarcToSolr
SOLR_DOC_FREQUENT=${SOLR_DOC_BASE}/FrequentInitialPreProcessing

LOCAL_BASE=${MY_DEVELOP_DEPLOY}document.processing
LOCAL_MARC=${LOCAL_BASE}/Marc2SOLR/deploy
#LOCAL_PREDOC=${LOCAL_BASE}/PreDocProcessing/prod/2012.03/deploy/solr
LOCAL_DELETE=${LOCAL_BASE}/DeleteDocs/dist


#for host in sb-s2.swissbib.unibas.ch sb-s8.swissbib.unibas.ch
for host in sb-s1.swissbib.unibas.ch

do

    ssh swissbib@$host "test -d ${SOLR_DOC_MARC}/dist && rm -r ${SOLR_DOC_MARC}/dist && mkdir -p ${SOLR_DOC_MARC}/dist"
    ssh swissbib@$host "test -d ${SOLR_DOC_MARC}/delete  && rm -r ${SOLR_DOC_MARC}/delete && mkdir -p ${SOLR_DOC_MARC}/delete"
    ssh swissbib@$host "test -d ${SOLR_DOC_MARC}/libs && rm -r ${SOLR_DOC_MARC}/libs && mkdir -p ${SOLR_DOC_MARC}/libs"
    ssh swissbib@$host "test -d ${SOLR_DOC_MARC}/xslt && rm -r ${SOLR_DOC_MARC}/xslt && mkdir -p ${SOLR_DOC_MARC}/xslt"
    ssh swissbib@$host "test -d ${SOLR_DOC_MARC}/xsltskipRecords && rm -r ${SOLR_DOC_MARC}/xsltskipRecords && mkdir -p ${SOLR_DOC_MARC}/xsltskipRecords"
    ssh swissbib@$host "test -d ${SOLR_DOC_FREQUENT}/bin && rm -r ${SOLR_DOC_FREQUENT}/bin && mkdir -p ${SOLR_DOC_FREQUENT}/bin"


    cd ${LOCAL_MARC}

    scp -r dist swissbib@$host:${SOLR_DOC_MARC}
    scp -r libs swissbib@$host:${SOLR_DOC_MARC}
    scp -r xslt swissbib@$host:${SOLR_DOC_MARC}
    scp -r xsltskipRecords swissbib@$host:${SOLR_DOC_MARC}
    scp -r workflow/* swissbib@$host:${SOLR_DOC_FREQUENT}/bin


    cd ${LOCAL_DELETE}

    echo `pwd`
    scp -r * swissbib@$host:${SOLR_DOC_MARC}/delete


    #cd ${LOCAL_PREDOC}
    #echo `pwd`
    #scp -r bin swissbib@$host:${SOLR_DOC_FREQUENT}

    cd ${LOCAL_BASE}
    ssh swissbib@$host "chmod 744 ${SOLR_DOC_MARC}/dist/*.sh"
    ssh swissbib@$host "chmod 744 ${SOLR_DOC_MARC}/delete/*.sh"
    ssh swissbib@$host "chmod 744 ${SOLR_DOC_FREQUENT}/bin/*.sh"


done



