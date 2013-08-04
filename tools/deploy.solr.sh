#!/bin/sh

SOLR_DOC_BASE=/swissbib_index/solrDocumentProcessing
SOLR_DOC_MARC=${SOLR_DOC_BASE}/MarcToSolr
SOLR_DOC_FREQUENT=${SOLR_DOC_BASE}/FrequentInitialPreProcessing


#only for testing
#SOLR_DOC_BASE=/swissbib_index/solrDocumentProcessing
#SOLR_DOC_MARC=${SOLR_DOC_BASE}/MarcToSolr/testdeploy
#SOLR_DOC_FREQUENT=${SOLR_DOC_BASE}/FrequentInitialPreProcessing/testdeploy



LOCAL_BASE=$MY_BASEDOCPROC_DEPLOY

LOCAL_SUB_DIRS=test/2012.11

#LOCAL_MARC=${LOCAL_BASE}/Marc2SOLR/prod/2012.03/deploy
#LOCAL_PREDOC=${LOCAL_BASE}/PreDocProcessing/prod/2012.03/deploy/solr
#LOCAL_DELETE=${LOCAL_BASE}/DeleteDocs/prod/2012.03/dist

LOCAL_MARC=${LOCAL_BASE}/Marc2SOLR/deploy
LOCAL_PREDOC=${LOCAL_BASE}/PreDocProcessing/deploy/solr
LOCAL_DELETE=${LOCAL_BASE}/DeleteDocs/dist

#rm -r $LOCAL_MARC
#mkdir -p $LOCAL_MARC



for host in sb-s12.swissbib.unibas.ch
#for host in sb-s2.swissbib.unibas.ch sb-s8.swissbib.unibas.ch sb-s10.swissbib.unibas.ch
#for host in sb-s8.swissbib.unibas.ch
#for host in sb-s10.swissbib.unibas.ch
#for host in sb-s2.swissbib.unibas.ch
#for host in sb-s1.swissbib.unibas.ch

do

    ssh swissbib@$host "test -d ${SOLR_DOC_MARC}/dist && rm -r ${SOLR_DOC_MARC}/dist && mkdir -p ${SOLR_DOC_MARC}/dist"
    ssh swissbib@$host "test -d ${SOLR_DOC_MARC}/delete ||  mkdir -p ${SOLR_DOC_MARC}/delete"
    ssh swissbib@$host "test -d ${SOLR_DOC_MARC}/delete  && rm -r ${SOLR_DOC_MARC}/delete && mkdir -p ${SOLR_DOC_MARC}/delete"
    ssh swissbib@$host "test -d ${SOLR_DOC_MARC}/libs && rm -r ${SOLR_DOC_MARC}/libs && mkdir -p ${SOLR_DOC_MARC}/libs"
    ssh swissbib@$host "test -d ${SOLR_DOC_MARC}/xslt && rm -r ${SOLR_DOC_MARC}/xslt && mkdir -p ${SOLR_DOC_MARC}/xslt"
    #ssh swissbib@$host "test -d ${SOLR_DOC_MARC}/xsltViaf && rm -r ${SOLR_DOC_MARC}/xsltViaf && mkdir -p ${SOLR_DOC_MARC}/xsltViaf"
    ssh swissbib@$host "test -d ${SOLR_DOC_FREQUENT}/bin && rm -r ${SOLR_DOC_FREQUENT}/bin && mkdir -p ${SOLR_DOC_FREQUENT}/bin"


    cd ${LOCAL_MARC}

    scp -r dist swissbib@$host:${SOLR_DOC_MARC}
    scp -r libs swissbib@$host:${SOLR_DOC_MARC}
    scp -r xslt swissbib@$host:${SOLR_DOC_MARC}
    ##scp -r xsltViaf swissbib@$host:${SOLR_DOC_MARC}



    cd ${LOCAL_DELETE}

    echo `pwd`
    scp -r * swissbib@$host:${SOLR_DOC_MARC}/delete


    cd ${LOCAL_PREDOC}
    echo `pwd`
    scp -r bin swissbib@$host:${SOLR_DOC_FREQUENT}

    scp -r crontab.sb* swissbib@$host:~



    cd ${LOCAL_BASE}
    ssh swissbib@$host "chmod 744 ${SOLR_DOC_MARC}/dist/*.sh"
    ssh swissbib@$host "chmod 744 ${SOLR_DOC_MARC}/delete/*.sh"
    ssh swissbib@$host "chmod 744 ${SOLR_DOC_FREQUENT}/bin/*.sh"


done



