#!/bin/sh

#set -x


#source ${HOME}/DOCPREPROCESSING_ENVIRONMENT.sh


BINDIR=/home/swissbib/environment/code/documentprocessing/shellscriptsSOLR

SOURCEDIR=$1


TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds

printf "Start of the process formatting bulkload at  <%s> ...\n" $TIMESTAMP

for FILE in $SOURCEDIR/*.xml
do
FORMATFILE=`basename $FILE .raw.xml`
FORMATFILE=$FORMATFILE.notComposed.xml

printf "Formatting load file <%s> ...\n" $FORMATFILE
perl $BINDIR/BulkMarcRecordModifierSOLR.pl $FILE $SOURCEDIR/$FORMATFILE


done


TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds

printf "End of the process formatting bulkload at  <%s> ...\n" $TIMESTAMP

exit 0
