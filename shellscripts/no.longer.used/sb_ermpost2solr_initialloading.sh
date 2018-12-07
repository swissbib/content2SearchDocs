#!/bin/bash
#
# oliver.schihin@unibas.ch / 21.11.2011 : Skript erstellt
#
# bernd.luchner@unibas.ch / 17.12.2013 : Pfadanpassungen für ErmToSolr
#

PROJECTDIR_DOCPROCESSING=/swissbib_index/solrDocumentProcessing/ErmToSolr
LOGDIR=${PROJECTDIR_DOCPROCESSING}/data/log

CURRENT_TIMESTAMP=`date +%Y%m%d%H%M%S`
LOGFILE=$LOGDIR/InitialPostingTo.$CURRENT_TIMESTAMP.log
POSTDIRBASE=${PROJECTDIR_DOCPROCESSING}/data/outputfiles
POSTJAR=${PROJECTDIR_DOCPROCESSING}/dist/post.jar

#ulimit -v unlimited

function usage()
{
 printf "usage: $0 -s <URL solr index server> e.g. http://sb-s15.swissbib.unibas.ch:8080/solr/sb-biblio/update \n"
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

function post2solr ()
{
   for dir in `ls ${POSTDIRBASE}`
    do

       setTimestamp
       printf "start posting to SOLR in <%s>\n" ${dir} >> ${LOGFILE}

       printf "unzip the files with Search documents" >> ${LOGFILE}
       gunzip ${POSTDIRBASE}/$dir/*.gz

       POSTDIR=${POSTDIRBASE}/$dir/*.xml

       java -Xms1024m -Xmx1024m \
        -Durl=${URLSOLRINDEXSERVER} \
        -Dcommit=no   \
        -jar ${POSTJAR} ${POSTDIR} >> ${LOGFILE}

         printf "now send the commit to ${URLSOLRINDEXSERVER} ...\n"  >> ${LOGFILE}
            java  \
                -Durl=${URLSOLRINDEXSERVER} \
                -Dcommit=yes   \
                -jar ${POSTJAR}  >> ${LOGFILE}

       printf "now zip the posted files again" >> ${LOGFILE}
       gzip ${POSTDIRBASE}/$dir/*.xml

#        rm -r $file

    done
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

printf "sb_ermpost2solr_initialloading.sh started at <%s>: ... \n" ${CURRENT_TIMESTAMP} >> ${LOGFILE}

post2solr

setTimestamp
printf "sb_ermpost2solr_initialloading.sh finished at <%s>: ...\n" ${CURRENT_TIMESTAMP} >> ${LOGFILE}
