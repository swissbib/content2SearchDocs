#!/bin/bash
#
# oliver.schihin@unibas.ch / 21.11.2011


#ulimit -v unlimited

function repairid ()
{
    if [ ! -d $postdirbase ]
    then 
            printf "ERROR : base directory of posting does not exist!\n"
            exit 1
    fi

 
    for dirtop in `ls $postdirbase`
    do
        

        for filetoprocess in `ls ${postdirbase}/${dirtop}/`
        do
           
           echo ${postdirbase}/${dirtop}/${filetoprocess}

           
                
            java -jar saxon9.jar  -s:${postdirbase}/${dirtop}/${filetoprocess} -xsl:repairDocid.xsl > ${postdirbase}/${dirtop}/repaired.${filetoprocess}
               


           sed -i -f ./docidrepl.sed ${postdirbase}/${dirtop}/repaired.${filetoprocess}
           
           rm ${postdirbase}/${dirtop}/${filetoprocess}
              

        done
    done
}

PROJECTDIR_DOCPROCESSING=/swissbib_index/solrDocumentProcessing/MarcToSolr/data

postdirbase=${PROJECTDIR_DOCPROCESSING}/outputfiles.toproc
postjar=${PROJECTDIR_DOCPROCESSING}/saxon9.jar


TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds

repairid

TIMESTAMP=`date +%Y%m%d%H%M%S`	# seconds

