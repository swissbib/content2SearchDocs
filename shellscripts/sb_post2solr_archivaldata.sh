#!/bin/bash

# sb_post2solr_archivaldata.sh
# ****************************
# Description: Script posts search engine documents to the solr index specified on the command line
#              Collections concerned are not updated through frequent and automatic procedures but treated completely.
#              For re-indexing, delete all records first from index
#
# Authors: Günter Hipler (ghi), Oliver Schihin (osc)
#
# History
# 21.11.2011 : osc : Creation (generic version)
# 03.05.2012 : ghi : Extended
# 20.08.2015 : osc : Adaption to new setup of archival data indexing
#
# Generic path definitions and variables
PROJECTDIR_DOCPROCESSING=/swissbib_index/solrDocumentProcessing/MarcToSolr
LOGDIR=${PROJECTDIR_DOCPROCESSING}/data/log
CURRENT_TIMESTAMP=`date +%Y%m%d%H%M%S`
LOGFILE=$LOGDIR/post2solrArchivaldata.$CURRENT_TIMESTAMP.log
POSTDIRBASE=${PROJECTDIR_DOCPROCESSING}/data/outputfiles_archivaldata
POSTJAR=${PROJECTDIR_DOCPROCESSING}/dist/post.jar

#ulimit -v unlimited

function usage()
{
 printf "usage: $0 -s <URL solr index server>\n"
}

function setTimestamp()
{
    CURRENT_TIMESTAMP=`date +%Y%m%d%H%M%S`
}

function preChecks()
{
    printf "in preChecks ...\n" >> $LOGFILE

    if [ ! -d ${POSTDIRBASE} ]
    then
            printf "ERROR : base directory for files to be posted does not exist!\n" >>$LOGFILE && exit 9
    fi

    #-z: the length of string is zero
    [ -z  ${URLSOLRINDEXSERVER} ] && usage

    #-n: True if the length of "STRING" is non-zero.
    [ ! -n "${URLSOLRINDEXSERVER}" ] && echo "solr index server  is not set" >>$LOGFILE && exit 9
}

# Indexing function
function post2solr()
{
   for dir in `ls ${POSTDIRBASE}`
   do
       setTimestamp
       printf "start posting to SOLR in <%s>\n" ${dir} >> ${LOGFILE}

       POSTDIR=${POSTDIRBASE}/$dir/*.xml

       java -Xms1024m -Xmx1024m \
            -Durl=${URLSOLRINDEXSERVER} \
            -Dcommit=no   \
            -jar ${POSTJAR} ${POSTDIR} >> ${LOGFILE}
    done

    printf "now send the commit to <%s> ...\n" ${URLSOLRINDEXSERVER} >> ${LOGFILE}
    java  \
        -Durl=${URLSOLRINDEXSERVER} \
        -Dcommit=yes   \
        -jar ${POSTJAR}  >> ${LOGFILE}
}

while getopts hs: OPTION
do
  case $OPTION in
    h) usage
	exit 9
	;;
    s) URLSOLRINDEXSERVER=$OPTARG;;		# URL index server

    *) printf "unknown option -%c\n" $OPTION; usage; exit;;
  esac
done

preChecks

setTimestamp

printf "sb_post2solr_archivaldata.sh started at <%s>: ... \n" ${CURRENT_TIMESTAMP} >> ${LOGFILE}

post2solr

setTimestamp
printf "sb_post2solr_archivaldata.sh finished at <%s>: ...\n" ${CURRENT_TIMESTAMP} >> ${LOGFILE}
