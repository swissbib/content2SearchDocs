#!/bin/bash
#
# version 1.0 project swissbib UB Basel, Guenter Hipler, 2012-04-24

PROJECTDIR_DOCPREPROCESSING=/swissbib_index/solrDocumentProcessing/FrequentInitialPreProcessing
PROJECTDIR_DOCPROCESSING=/swissbib_index/solrDocumentProcessing/MarcToSolr



#variables for holdings processing (update and delete)
CURRENT_TIMESTAMP=`date +%Y%m%d%H%M%S`

LOGDIR=${PROJECTDIR_DOCPREPROCESSING}/log/update


POSTJAR=${PROJECTDIR_DOCPROCESSING}/dist/post.jar
LOGSPOST2SOLR=${LOGDIR}/post2SOLR.${CURRENT_TIMESTAMP}.log

POSTDIRBASE_FROM=${PROJECTDIR_DOCPROCESSING}/data/outputfilesFrequent
POSTDIRBASE_TO=${PROJECTDIR_DOCPROCESSING}/data/outputfilesFrequentProcess

ARCHIVE_DIR=${PROJECTDIR_DOCPROCESSING}/data/archiveFilesFrequent

POSTJAR=${PROJECTDIR_DOCPROCESSING}/dist/post.jar


function setTimestamp()
{
    CURRENT_TIMESTAMP=`date +%Y%m%d%H%M%S`
}



function usage()
{
 printf "usage: $0 -s <url solr service>\n"
}



function preChecks()
{

    printf "in preChecks of sb_post2Solr_Frequent.sh...\n" >> ${LOGSPOST2SOLR}

    [ -z  ${INDEXINGMASTERURL} ] && usage

    [ ! -n "${INDEXINGMASTERURL}" ] && echo "URL for SOLR service  is not set" >>${LOGSPOST2SOLR} && exit 9


    #-z: the length of string is zero

    if [ ! -d ${POSTDIRBASE_TO} ]
    then
        printf "Creating dir <%s> ... \n" ${POSTDIRBASE_TO} >> ${LOGSPOST2SOLR}
        mkdir -p ${POSTDIRBASE_TO}
    fi


    if [ ! -d ${POSTDIRBASE_FROM} ]
    then
        printf "Directory with SOLR documents for posting  does not exist <%s> !\n" ${POSTDIRBASE_FROM} >> ${LOGSPOST2SOLR}
        exit 1
    fi


    #Check if frequent update process running: test lock file
    LOCKFILEFREQUENT=${PROJECTDIR_DOCPREPROCESSING}/.SOLRdocprocessingPID
    if [ -f $LOCKFILEFREQUENT ]
    then
      PID=`cat $LOCKFILEFREQUENT`
      ps -fp $PID >/dev/null 2>&1
      if [ $? -eq 0 ]
      then
        printf "Frequent Update process %s is still running \n
                posting to index and preparation of documents at
                the same time shouldn't be done. Exit\n" $PID >> ${LOGSPOST2SOLR}
        exit 0
      fi
    fi

    LOCKFILEPOSTING=${PROJECTDIR_DOCPROCESSING}/.SOLRPostingToIndexPID
    if [ -f $LOCKFILEPOSTING ]
    then
      PID=`cat $LOCKFILEPOSTING`
      ps -fp $PID >/dev/null 2>&1
      if [ $? -eq 0 ]
      then
        printf "Posting to index process %s is still running \n . Exit\n" $PID >> ${LOGSPOST2SOLR}
        exit 0
      fi
    fi


    #write PID in lock file
    echo $$ >$LOCKFILEPOSTING

}



function moveDocuments()
{

    printf "moving Document at <%s> ...\n" ${CURRENT_TIMESTAMP} >> ${LOGSPOST2SOLR}

    #-z: the length of string is zero

    cd ${POSTDIRBASE_FROM}

    mv  * ${POSTDIRBASE_TO}




}




function post2solr ()
{


    setTimestamp
    printf "starting to post documents to SOLR at <%s> ...\n" ${CURRENT_TIMESTAMP} >> ${LOGSPOST2SOLR}

    for d in `ls ${POSTDIRBASE_TO}`
        do
        printf "starting to post documents to <%s> in directory  <%s> without commit...\n" ${INDEXINGMASTERURL} ${d} >> ${LOGSPOST2SOLR}
        POSTDIR=${POSTDIRBASE_TO}/${d}/*.xml

        #we don't want a commit for every package as the result of update job which is started regularly
        #the whole day (often every two hours)
        #there should be only one commit at the end of the whole process
        java -Xms1024m -Xmx1024m \
            -Durl=${INDEXINGMASTERURL} \
            -Dcommit=no   \
            -jar ${POSTJAR} ${POSTDIR} >> ${LOGSPOST2SOLR}

        #rm -r ${POSTDIRBASE_TO}/${d}



    done

    #now start the commit
    printf "now send the commit to <%s> ...\n" ${INDEXINGMASTERURL} >> ${LOGSPOST2SOLR}
    java  \
        -Durl=${INDEXINGMASTERURL} \
        -Dcommit=yes   \
        -jar ${POSTJAR}  >> ${LOGSPOST2SOLR}


}


function archiveAndZip()
{

    setTimestamp
    printf "starting to archive SOLR documents  at <%s> ...\n" ${CURRENT_TIMESTAMP} >> ${LOGSPOST2SOLR}


    tar zcf ${ARCHIVE_DIR}/PostedSolrDocuments${CURRENT_TIMESTAMP}.tar.gz   ${POSTDIRBASE_TO}/* --remove-files

}



while getopts hs:d: OPTION
do
  case $OPTION in
    h) usage
	exit 9
	;;
    s) INDEXINGMASTERURL=$OPTARG;;		# URL SOLR service

    *) printf "unknown option -%c\n" $OPTION; usage; exit;;
  esac
done


preChecks
setTimestamp
moveDocuments
post2solr
archiveAndZip

rm -f $LOCKFILEPOSTING


setTimestamp
printf "posting documents to SOLR finished at <%s> ...\n" ${CURRENT_TIMESTAMP} >> ${LOGSPOST2SOLR}
