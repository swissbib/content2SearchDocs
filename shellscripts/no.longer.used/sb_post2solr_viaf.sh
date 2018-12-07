#!/bin/bash
#
# oliver.schihin@unibas.ch / 21.11.2011
#erweitert: Guenter Hipler 3.5.2012

PROJECTDIR_DOCPROCESSING=/swissbib_index/solrDocumentProcessing/VIAF
LOGDIR=${PROJECTDIR_DOCPROCESSING}/data/log



CURRENT_TIMESTAMP=`date +%Y%m%d%H%M%S`
LOGFILE=$LOGDIR/InitialPostingTo.$CURRENT_TIMESTAMP.log
POSTDIRBASE=${PROJECTDIR_DOCPROCESSING}/data/outputfiles/20120422
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


function post2solr ()
{


       setTimestamp
       printf "start posting to SOLR files in <%s>\n" ${POSTDIRBASE} >> ${LOGFILE}

       FILES=${POSTDIRBASE}/*.xml

       java -Xms1024m -Xmx1024m \
        -Durl=${URLSOLRINDEXSERVER} \
        -jar ${POSTJAR} ${FILES} >> ${LOGFILE}



#Variante
#   for dir in `ls ${POSTDIRBASE}`
#    do
#       setTimestamp
#       printf "start posting to SOLR in <%s>\n" ${dir} >> ${LOGFILE}
#       POSTDIR=${POSTDIRBASE}/$dir/*.xml
#       java -Xms1024m -Xmx1024m \
#            -Durl=${URLSOLRINDEXSERVER} \
#            -Dcommit=no   \
#            -jar ${POSTJAR} ${POSTDIR} >> ${LOGFILE}


#        printf "now send the commit to <%s> ...\n" ${URLSOLRINDEXSERVER} >> ${LOGFILE}
#        java  \
#            -Durl=${URLSOLRINDEXSERVER} \
#            -Dcommit=yes   \
#            -jar ${POSTJAR}  >> ${LOGFILE}
#    done





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

printf "sb_post2solr_initialloading.sh started at <%s>: ... \n" ${CURRENT_TIMESTAMP} >> ${LOGFILE}

post2solr

setTimestamp
printf "sb_post2solr_initialloading.sh finished at <%s>: ...\n" ${CURRENT_TIMESTAMP} >> ${LOGFILE}
