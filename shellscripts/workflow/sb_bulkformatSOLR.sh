#!/bin/sh

#set -x

#source ${HOME}/DOCPREPROCESSING_ENVIRONMENT.sh

PROJECTDIR_DOCPREPROCESSING=/swissbib_index/solrDocumentProcessing/FrequentInitialPreProcessing

SOURCEDIR=$PROJECTDIR_DOCPREPROCESSING/data/raw
FORMATDIR=$PROJECTDIR_DOCPREPROCESSING/data/format

if [ ! -d $PROJECTDIR_DOCPREPROCESSING ]
then
	printf "PROJECTDIR does not exist <%s> !\n" $PROJECTDIR_DOCPREPROCESSING
	exit 1
fi

if [ ! -d $SOURCEDIR ]
then
	printf "SOURCEDIR does not exist <%s> !\n" $SOURCEDIR
	exit 1
fi

if [ ! -d $FORMATDIR ]
then
	printf "Creating dir <%s> ... \n" $FORMATDIR
	mkdir $FORMATDIR
fi

TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds

printf "Start of the process formatting bulkload at  <%s> ...\n" $TIMESTAMP

for FILE in $SOURCEDIR/*.raw.xml.gz
do
gunzip $FILE
RAWFILE=`basename $FILE .raw.xml.gz`

FORMATFILE=$RAWFILE.format.xml
printf "Formatting load file <%s> ...\n" $FORMATFILE
perl BulkMarcRecordModifierSOLR.pl $SOURCEDIR/$RAWFILE.raw.xml $FORMATFILE
printf "Zip and move load file <%s> ...\n" $FORMATFILE
gzip $FORMATFILE
mv $FORMATFILE.gz $FORMATDIR
gzip $SOURCEDIR/$RAWFILE.raw.xml
done

TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds

printf "End of the process formatting bulkload at  <%s> ...\n" $TIMESTAMP

exit 0
