#!/bin/bash

#set -x

#source ${HOME}/DOCPREPROCESSING_ENVIRONMENT.sh

PROJECTDIR_DOCPREPROCESSING=/swissbib_index/solrDocumentProcessing/FrequentInitialPreProcessing
PROJECTDIR_DOCPROCESSING=/swissbib_index/solrDocumentProcessing/MarcToSolr

FORMATDIR=${PROJECTDIR_DOCPREPROCESSING}/data/formatskipccsa
SOURCEDIR=${PROJECTDIR_DOCPROCESSING}/data/inputskipccsa
LOGDIR=${PROJECTDIR_DOCPREPROCESSING}/log/dbholdings
WORKINGDIR=${PROJECTDIR_DOCPREPROCESSING}/bin


CURRENT_TIMESTAMP=`date +%Y%m%d%H%M%S`
LOGFILE=$LOGDIR/InitialWeedingccsa.$CURRENT_TIMESTAMP.log



function usage()
{
 printf "usage: $0 -w <weeding mode LONG [swissbib green] or SHORT [basel bern]>\n"
}


function setTimestamp()
{
    CURRENT_TIMESTAMP=`date +%Y%m%d%H%M%S`
}


function initialize()
{
        if [ ! -d ${PROJECTDIR_DOCPREPROCESSING} ]
        then
	        printf "PROJECTDIR does not exits <%s> ! \n" ${PROJECTDIR_DOCPREPROCESSING}
	        exit 1
        fi

        if [ ! -d $FORMATDIR ]
        then
	        printf "FORMATDIR does not exits <%s> ! \n" $FORMATDIR
	        exit 1
        fi

        if [ ! -d $LOGDIR ]
        then
	        printf "Creating dir <%s> ... \n" $LOGDIR
	        mkdir -p $LOGDIR
        fi

        if [ ! -d $SOURCEDIR ]
        then
	        printf "Creating dir <%s> ... \n" $SOURCEDIR
	        mkdir -p $SOURCEDIR
        fi
        
} 


function preChecks()
{

    printf "in preChecks ...\n" >> $LOGFILE

    #-z: the length of string is zero
    [ -z  $WEEDINGMODE ] && usage

    #-n: True if the length of "STRING" is non-zero.
    [ ! -n "$WEEDINGMODE" ] && echo "weeding mode  is not set" >>$LOGFILE && exit 9

    if test $WEEDINGMODE != 'SHORT' && test $WEEDINGMODE != 'LONG'
    then
       echo "weeding mode  is either SHORT nor LONG" >> $LOGFILE && exit 9
    fi
}


function processHoldings()
{
        setTimestamp

        printf "in process Holdings ...<%s>  \n" ${CURRENT_TIMESTAMP} >> $LOGFILE

        cd ${PROJECTDIR_DOCPREPROCESSING}/bin/holdings


        if test ${WEEDINGMODE} = 'LONG'
        then

            printf "weeding mode is LONG ->  all records will be processed according to xslt/weedholdings.xsl \n"  >> $LOGFILE
            for FILE in $FORMATDIR/*.format.xml
            do
                    FORMATFILE=`basename $FILE .format.xml`
                    FORMATFILE=$FORMATFILE.no_holdings.xml

                    setTimestamp
                    printf "Formatting load file <%s> ...\n" ${CURRENT_TIMESTAMP} >> ${LOGFILE}

                    LOGCONFIG=logconfig/predocprocessing.SOLR.log4j.xml
                    java -Xms1024m -Xmx1024m  \
                            -Dlog4j.configuration=${LOGCONFIG} \
                            -jar holdings.processing.jar    --input=${FILE} \
                                                                    --map=props/HoldingsCodeMap.properties \
                                                                    --transformerimpl=net.sf.saxon.TransformerFactoryImpl \
                                                                    --transformerscript=xslt/weedholdings.xsl  \
                                                                    --weed-xml \
                                                                    > ${FORMATFILE}


                    mv $FORMATFILE $SOURCEDIR
                    setTimestamp

                    printf "Endtime for formatting the file <%s> ...\n" ${CURRENT_TIMESTAMP} >> ${LOGFILE}


            done


        else

            printf "weeding mode is SHORT ->  skipping records according to xslt/weedholdings.basel.xsl and xslt/belongs.2.basel.repository.xslt \n" ${CURRENT_TIMESTAMP} >> $LOGFILE
            for FILE in $FORMATDIR/*.format.xml
            do
                    FORMATFILE=`basename $FILE .format.xml`
                    FORMATFILE=$FORMATFILE.no_holdings.xml

                    setTimestamp
                    printf "Formatting load file <%s> ...\n" ${CURRENT_TIMESTAMP} >> ${LOGFILE}

                    LOGCONFIG=logconfig/predocprocessing.SOLR.log4j.xml
                    java -Xms1024m -Xmx1024m  \
                            -Dlog4j.configuration=${LOGCONFIG} \
                            -jar holdings.processing.jar    --input=${FILE} \
                                                                    --map=props/HoldingsCodeMap.properties \
                                                                    --transformerimpl=net.sf.saxon.TransformerFactoryImpl \
                                                                    --transformerscript=xslt/weedholdings.basel.xsl  \
                                                                    --skipRecordT=xslt/weed.out.ccsa.xslt \
                                                                    --skip-only \
                                                                    > ${FORMATFILE}


                    mv $FORMATFILE $SOURCEDIR
                    setTimestamp

                    printf "Endtime for formatting the file <%s> ...\n" ${CURRENT_TIMESTAMP} >> ${LOGFILE}


            done




        fi



        cd ${PROJECTDIR_DOCPREPROCESSING}/bin
}

initialize


#it seems getopts doesn't run in within function scope...
while getopts hw: OPTION
do
  case $OPTION in
    h) usage
	exit 9
	;;
    w) WEEDINGMODE=$OPTARG;;		# swissbib green or Basel / Bern

    *) printf "unknown option -%c\n" $OPTION; usage; exit;;
  esac
done


preChecks


processHoldings



printf "Formatting load files DONE.\n"
exit 0
