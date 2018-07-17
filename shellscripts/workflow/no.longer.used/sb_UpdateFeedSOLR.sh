#!/bin/bash
#
#

#call this script
#./UpdateFeedSwissBibSOLR.sh -shttp://sb-s1.swissbib.unibas.ch/solr/ -d/swissbib_index/solrDocumentProcessing/FrequentInitialPreProcessing/data/update/request

#set +x

#source ${HOME}/DOCPREPROCESSING_ENVIRONMENT.sh

PROJECTDIR_DOCPREPROCESSING=/swissbib_index/solrDocumentProcessing/FrequentInitialPreProcessing
PROJECTDIR_DOCPROCESSING=/swissbib_index/solrDocumentProcessing/MarcToSolr



#variables for holdings processing (update and delete)
TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds
TRANSDIR=${PROJECTDIR_DOCPREPROCESSING}/feed	# default
DATADIR=${PROJECTDIR_DOCPREPROCESSING}/data/update/load
ARCHIVEDIR=${PROJECTDIR_DOCPREPROCESSING}/data/update/archive
LOGDIR=${PROJECTDIR_DOCPREPROCESSING}/log/update
DELETEDIR=${PROJECTDIR_DOCPREPROCESSING}/data/update/delete
UPDATEDIR=""	 	# option d set with optargs
LOGCONFIGHOLDINGS=predocprocessing.log4j.xml
LOGCONFIGmarc2SOLR=marcxml2solrlog4j.xml

#variables for document processing (marc2SOLR)

xsltPath=${PROJECTDIR_DOCPROCESSING}/xslt
inputpath=${PROJECTDIR_DOCPROCESSING}/data/inputfilesFrequent
confFile=${PROJECTDIR_DOCPROCESSING}/dist/config.properties
outDirBase=${PROJECTDIR_DOCPROCESSING}/data/outputfilesFrequent
postjar=${PROJECTDIR_DOCPROCESSING}/dist/post.jar
marc2Solrjar=${PROJECTDIR_DOCPROCESSING}/dist/xml2SearchEngineDoc.jar
logSendToSolr=${PROJECTDIR_DOCPROCESSING}/data/log/post2SOLR.log
logscriptflow=${PROJECTDIR_DOCPROCESSING}/data/log/sb_marc2solr_frequent.log
outputsubdir=outsub

DELETEDIR_SOLR=${PROJECTDIR_DOCPROCESSING}/delete

CURRENT_TIMESTAMP=`date +%Y%m%d%H%M%S`

LOGFILE=$LOGDIR/Load.$TIMESTAMP.log

BULKFILE_TIMESTAMP=`date +%Y%m%d%H%M%S`
DELETE_TIMESTAMP=`date +%Y%m%d%H%M%S`



function usage()
{
 printf "usage: $0 [-c <optional config file - default config.properties]> -d <directory>\n"
}
 
function initialize()
{
    printf "in initialize ...\n" >> $LOGFILE


    if [ ! -d ${PROJECTDIR_DOCPREPROCESSING} ]
    then
        printf "Directory for preprocessing  does not exist <%s> !\n" ${PROJECTDIR_DOCPREPROCESSING}
        exit 1
    fi

    if [ ! -d ${DATADIR} ]
    then
        printf "DATADIR does not exist <%s> !\n" $DATADIR
        exit 1
    fi

    if [ ! -d ${LOGDIR} ]
    then
        printf "Creating dir <%s> ... \n" ${LOGDIR}
        mkdir -p ${LOGDIR}
    fi

    if [ ! -d ${ARCHIVEDIR} ]
    then
        printf "Creating dir <%s> ... \n" ${ARCHIVEDIR}
        mkdir -p ${ARCHIVEDIR}
    fi

    if [ ! -d ${DELETEDIR} ]
    then
        printf "Creating dir <%s> ... \n" ${DELETEDIR}
        mkdir -p ${DELETEDIR}
    fi

    if [ ! -d ${inputpath} ]
    then
        printf "Creating dir <%s> ... \n" ${inputpath}
        mkdir -p ${inputpath}
    fi

    if [ ! -d ${outDirBase} ]
    then
        printf "Creating dir <%s> ... \n" ${outDirBase}
        mkdir -p ${outDirBase}
    fi



#TODO:  evaluate if there are all directories for document processing (marc2SOLR)

}


function preChecks()
{

    printf "in preChecks ...\n" >> $LOGFILE

    #-z: the length of string is zero
    [ -z  $CONFIGFILE ] && CONFIGFILE="config.properties"
    [ -z $UPDATEDIR ] && usage && printf "UPDATEDIR is not defined " >> $LOGFILE &&  exit 9

    #-n: True if the length of "STRING" is non-zero.
    #[ ! -n "$WEEDINGMODE" ] && echo "weeding mode  is not set" >>$LOGFILE && exit 9
    [ ! -d "$UPDATEDIR" ] && printf "UPDATEDIR is not a directory" >>$LOGFILE && exit 9

    printf "UpdateDir for collected CBS messages: <%s>... \n" $UPDATEDIR >> $LOGFILE



    # Check if there are any updates at all
    #U:  do not sort; list entries in directory order
    if [ ! "$(ls -U $UPDATEDIR)" ]
    then
      printf "Update directory empty: <%s>, no updates for indexing. Exit\n" $UPDATEDIR >> $LOGFILE
      exit 9
    fi

    # Check if working directory is empty
    if [ "$(ls -U $DATADIR)" ]
    then
      printf "Update load directory not empty: <%s>. Please clear directory first. Exit\n" $DATADIR >> $LOGFILE
      exit 9
    fi

    # check for empty feed dir
    if [ "$(ls -U $TRANSDIR)" ]
    then
     printf "Feed directory not empty: <%s> Please clear directory first. Exit\n" $TRANSDIR >> $LOGFILE
     exit 9
    fi



    #Check if previous update process running: test lock file
    LOCKFILE=${PROJECTDIR_DOCPREPROCESSING}/.SOLRdocprocessingPID
    if [ -f $LOCKFILE ]
    then
      PID=`cat $LOCKFILE`
      ps -fp $PID >/dev/null 2>&1
      if [ $? -eq 0 ]
      then
        printf "Update process %s is still running. Exit\n" $PID >> $LOGFILE
        exit 0
      fi
    fi

    #write PID in lock file
    echo $$ >$LOCKFILE

}


function setTimestamp()
{
    CURRENT_TIMESTAMP=`date +%Y%m%d%H%M%S`
}

function processHoldingsDelete()
{

    printf "in processHoldingsDelete ...\n" >> $LOGFILE

    cd ${DATADIR}

    # Delete requests will be moved in an extra directory and treated differently

    setTimestamp
    printf "starting grep looking for delete messages at  <%s>...\n" ${CURRENT_TIMESTAMP}  >> $LOGFILE
    DELETEIDS=`find . -name "REQ_*.xml" | xargs -i grep -l '<ucp:action>info:srw/action/1/delete</ucp:action>' {}`

    setTimestamp
    printf "finshed grep looking for delete messages at  <%s> ...\n" ${CURRENT_TIMESTAMP}  >> $LOGFILE



    if [ -n "$DELETEIDS" ]
    then
        for i in `echo $DELETEIDS`
        do
            printf "Moving file <%s> to delete dir: <%s>\n" $i $DELETEDIR >> $LOGFILE
            mv $i $DELETEDIR
        done

    #	printf "Moved files <%s> to delete dir: <%s>\n" $DELETEIDS $DELETEDIR >> $LOGFILE
        # create input file for delete operation, each id in a new line without any pre- or postfix
        echo $DELETEIDS | tr -d '/REQ_.xml' | tr -s [:blank:] '\n' > Deleteids_$TIMESTAMP
    #	printf "ID's to be deleted:\n`cat Deleteids_$TIMESTAMP`\n" >> $LOGFILE
        # check java executable and use java class FASTUpdDel with input file
        if [ -s Deleteids_$TIMESTAMP ]
        then

            setTimestamp

            #two underscores because should be sorted before the update file

            #should be sorted before updates
            outputsubdirDelete=${outDirBase}/${DELETE_TIMESTAMP}_AIdsToDelete

            mkdir -p ${outputsubdirDelete}

            cd $DELETEDIR_SOLR
            source ./deleteDocumentsInIndex.sh ${DATADIR}/Deleteids_$TIMESTAMP ${outputsubdirDelete} $LOGFILE
            [ $? -ne 0 ] && echo "ERROR in delete operation! Please check the details above.\n" >> $LOGFILE


            #no processing og holdings DB within SOLR Update
            mv $DATADIR/Deleteids_$TIMESTAMP $LOGDIR
        fi

        for DELETEFILE in $DELETEDIR/REQ_*.xml
        do
           mv $DELETEFILE $ARCHIVEDIR
           #rm $DELETEFILE
        done

        setTimestamp
        printf "processing of files to be deleted done at <%s>.\n" $CURRENT_TIMESTAMP >> $LOGFILE


    else
        printf "No delete requests available.\n" >> $LOGFILE
    fi



}

function checkLoadDirTransdir()
{
    printf "in checkLoadDirTransdir ...\n" >> $LOGFILE

    if [ ! "$(ls -U $DATADIR)" ]
    then
      printf "Update load directory empty (nach DELETE Operation) : <%s>, no further updates for indexing. Exit\n" $DATADIR >> $LOGFILE
      rm -f $LOCKFILE
      exit 9
    fi


}




function prepareRecordsForSearchDocsEngine()
{


    #### prepare records operation ################################
    # records from datahub to be updated in SearchEngine are prepared
    # - encoding NFC
    # - remove all the SRW namespaces
    # - 1 record for each line


    setTimestamp

    printf "in processHoldingsUpdate ...\n" >> $LOGFILE


    # check for empty dir
    if [ "$(ls -U $TRANSDIR)" ]
    then
         printf "Feed directory $TRANSDIR not empty ...\n"  >> $LOGFILE
         printf "Moving files to ${PROJECTDIR_DOCPREPROCESSING}/tmp ...\n" >> $LOGFILE
         mv *.xml ${PROJECTDIR_DOCPREPROCESSING}/tmp
    else
        printf "Feed directory $TRANSDIR is empty. \n"  >> $LOGFILE
    fi


    cd $DATADIR

    FORMATFILE=${BULKFILE_TIMESTAMP}_Bulkupdate_2SearchDocs

    printf "now in datadir -> collecting all the Request messages into one bulkfile ...<%s>\n" $FORMATFILE >> $LOGFILE

    find ./ -name 'REQ_*.xml' | while read file; do cat "${file}" >> $FORMATFILE;  rm -f $file; done

    printf "finished to create FORMATFILE  ...<%s>\n" ${FORMATFILE} >> $LOGFILE

    cd ${PROJECTDIR_DOCPREPROCESSING}/bin



    setTimestamp
    printf "Starting perl script MarcRecordModifierSOLR.pl at <%s>...\n" ${CURRENT_TIMESTAMP} >> $LOGFILE

    perl MarcRecordModifierSOLR.pl ${DATADIR}/${FORMATFILE} ${FORMATFILE}.xml >> $LOGFILE 2>&1


    setTimestamp
    printf "finished perl script MarcRecordModifierSOLR.pl at <%s>...\n" ${CURRENT_TIMESTAMP} >> $LOGFILE

    CURRENT_DIR=`pwd`
    printf "current dir ... <%s>\n" ${CURRENT_DIR} >> $LOGFILE


    #perl ProcessHoldingsData.pl --conf=ProcessHoldingsData.conf --map=HoldingsCodeMap.txt --input=$FORMATFILE.xml -db update -weed > $LOADFILE 2>> $LOGFILE
    mv $DATADIR/$FORMATFILE $ARCHIVEDIR
    #rm -f $DATADIR/$FORMATFILE

    mv $FORMATFILE.xml $TRANSDIR


}


function documentProcessingMarc2SearchEngineDoc()
{

    printf "in documentProcessingMarc2SOLR ...\n" >> $LOGFILE


    cd $TRANSDIR
    printf "moving  `ls -U | wc -l` files to the component for SOLR document processing ...\n" >> $LOGFILE

    cd ${PROJECTDIR_DOCPROCESSING}/dist
    #Transformation of marc records into SOLR structure  -> start of SOLR Feeding


    nr=1
    for datei in ${TRANSDIR}/*.xml
    do
        #actually the name convention I assume is only possible for initial loading
        setTimestamp
        outputsubdir=$CURRENT_TIMESTAMP_`basename ${datei} .xml`
        outputsubdirdetail=${outDirBase}/${outputsubdir}

        #outputsubdirdetail=${outDirBase}/${outputsubdir}${nr}


        #echo ${outputsubdirdetail}
        mkdir -p ${outputsubdirdetail}

        setTimestamp
        printf "start of processing [`basename ${datei}`] - see logfiles for more details - at: <%s> \n" $CURRENT_TIMESTAMP >> ${LOGFILE}


        java -Xms2048m -Xmx2048m  \
            -Dlog4j.configuration=${LOGCONFIGmarc2SOLR}     \
            -DLOGDEDUPLICATION=false                        \
            -DINPUT.FILE=${datei}                           \
            -DCONF.ADDITIONAL.PROPS.FILE=${confFile}        \
            -DOUTPUT.DIR=${outputsubdirdetail}              \
            -DTARGET.SEARCHENGINE=org.swissbib.documentprocessing.solr.XML2SOLRDocEngine \
            -DXPATH.DIR=${xsltPath}                         \
            -DSKIPRECORDS=false                             \
            -jar ${marc2Solrjar}

        #setTimestamp
        #printf "start posting to SOLR - see logfiles for more details - at <%s>:" ${CURRENT_TIMESTAMP} >> ${LOGFILE}
        #echo "posting to SOLR is currently supressed"  >> ${LOGFILE}

        #java -Xms1024m -Xmx1024m \
        #    -Durl=${SOLR}update   \
        #     -jar ${postjar} $outputsubdirdetail/*.xml >> ${logSendToSolr}

        #setTimestamp
        #printf "finished posting to SOLR - at <%s>:" ${CURRENT_TIMESTAMP} >> ${LOGFILE}

        #rm -r $outputsubdirdetail
        #nr=$((${nr}+1))


    done

    # optimize
#    TIMESTAMP=`date +%Y%m%d%H%M%S`  # seconds
#    echo "start SOLR optimize "${TIMESTAMP} >> ${LOGFILE}
#    java -Durl=${SOLR}update -Ddata=args -jar ${postjar} "<optimize />" >> ${logSendToSolr}

    printf "\n\n" >> $LOGFILE
    setTimestamp

    printf "process of transformation  MARC Structure  to SOLR Document structure has finished at: <%s>\n" $CURRENT_TIMESTAMP >> $LOGFILE
    printf "\n\n" >> $LOGFILE



}


###### MAIN #######

setTimestamp
printf "Starting frequent Index update (sb_UpdateFeedSOLR.sh)  at <%s>...\n" ${CURRENT_TIMESTAMP} >> $LOGFILE

DELETE_TIMESTAMP = `date +%Y%m%d%H%M%S`

#we need some time to set a later timestamp as part of the bulkfile name
sleep 5

#>>>>>>>>>>>>>>>>>>>>>>>>>>#call for initialization
initialize

#it seems getopts doesn't run in within function scope...
while getopts hc:d: OPTION
do
  case $OPTION in
    h) usage
	exit 9
	;;
    c) CONFIGFILE=$OPTARG;;		# swissbib green or Basel / Bern
    d) UPDATEDIR=$OPTARG;;
    
    *) printf "unknown option -%c\n" $OPTION; usage; exit;;
  esac
done





#>>>>>>>>>>>>>>>>>>>>>>>>>>#call for prechecks
preChecks



#### Update process is now ready to start: Move current records in tmp load directory ################################
#First stop tomcat, then clear update dir, afterwards restart tomcat
#stopping tomcat; setting lang variable for correct encoding (chb-420) important for startup
printf "Stopping tomcat.\n" >> ${LOGFILE}


#Sprache umstellen, da Tomcat im crontab mode nicht die Umgebungsvariablen des accounts auswertet
export LANG=en_US.UTF-8
${PROJECTDIR_DOCPREPROCESSING}/catcher/tomcat/bin/shutdown.sh -force >> ${LOGFILE}

cd ${UPDATEDIR}
printf "Starting update procedure at <%s> for `ls -U | wc -l` files ...\n" ${TIMESTAMP} >> ${LOGFILE}

# move proceeded update records away from SRURecordUpdate directory
find ${UPDATEDIR} -name "REQ_*.xml" -print | xargs -i mv {} ${DATADIR}

#starting tomcat to receive further requests
printf "Starting tomcat .\n" >> $LOGFILE
${PROJECTDIR_DOCPREPROCESSING}/catcher/tomcat/bin/startup.sh >> $LOGFILE


BULKFILE_TIMESTAMP = `date +%Y%m%d%H%M%S`


#>>>>>>>>>>>>>>>>>>>>>>>>>>#call for DB - deletes (Holdings) and deletions on in index in search engine
processHoldingsDelete

# Delete action finished

cd ${PROJECTDIR_DOCPREPROCESSING}/bin


checkLoadDirTransdir

#>>>>>>>>>>>>>>>>>>>>>>>>>>#call for preParation of raw records sent from datahub
prepareRecordsForSearchDocsEngine


#>>>>>>>>>>>>>>>>>>>>>>>>>>#call for document processing marc2SOLR
documentProcessingMarc2SearchEngineDoc
#end feeding SOLR index




cd $TRANSDIR
printf "Deleting files from <%s>  ...\n" $TRANSDIR >> $LOGFILE
find $TRANSDIR -name "*no_holdings.xml" -print | xargs -i mv {} $ARCHIVEDIR



# check for empty dir
if [ "$(ls -U $TRANSDIR)" ]
then
    printf "Feed directory not empty <%s> ...\n" $TRANSDIR >> $LOGFILE
    printf "Moving files to <%s> ...\n" ${PROJECTDIR_DOCPREPROCESSING}/tmp>> $LOGFILE
    mv *.xml ${PROJECTDIR_DOCPREPROCESSING}/tmp
else
    printf "Feed directory <%s> is empty .\n" $TRANSDIR >> $LOGFILE
fi

setTimestamp
printf "process of weeding records, deleting records in SOLR index and transformation  MARC Structure  to SOLR Document structure has finished at: <%s>\n" $CURRENT_TIMESTAMP >> $LOGFILE

rm -f $LOCKFILE

exit 0



