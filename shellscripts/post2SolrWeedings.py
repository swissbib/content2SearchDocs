__author__ = 'Guenter Hipler '
__copyright__ = 'Copyright (C) project swissbib, University Library Basel, Switzerland'
__license__ = """
        * http://opensource.org/licenses/gpl-2.0.php GNU General Public License
        * This program is free software; you can redistribute it and/or modify
        * it under the terms of the GNU General Public License version 2,
        * as published by the Free Software Foundation.
        *
        * This program is distributed in the hope that it will be useful,
        * but WITHOUT ANY WARRANTY; without even the implied warranty of
        * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        * GNU General Public License for more details.
        *
        * You should have received a copy of the GNU General Public License
        * along with this program; if not, write to the Free Software
        * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 """
__version__ = "0.9, 10.3.2015"
__maintainer__ = 'Guenter Hipler'
__email__ = 'guenter.hipler@unibas.ch'
__status__ = "in development"
__description__ = """
                    script to control the posting of documents which are weeded (shouldn't be part of the index) but are still part
                     of the index (because of processes in the past)
                     compare: https://github.com/swissbib/content2SearchDocs/issues/34
                """




import os,sys, time, subprocess
from datetime import datetime
from optparse import OptionParser



class Post2SolrFrequent:


    def __init__(self):

        self.PROJECTDIR_DOCPROCESSING = "/swissbib_index/solrDocumentProcessing/MarcToSolr"
        self.PROJECTDIR_DOCPREPROCESSING = "/swissbib_index/solrDocumentProcessing/FrequentInitialPreProcessing"
        self.LOGDIR = self.PROJECTDIR_DOCPREPROCESSING + "/log/update"
        self.POSTJAR = self.PROJECTDIR_DOCPROCESSING + "/dist/post.jar"
        self.LOGFILE = open (self.LOGDIR + os.sep + self.currentDateTime() + ".post2SolrWeededDocs.log","a")
        self.LOGSPOST2SOLR = self.LOGDIR + "/post2SOLR" +  self.currentDateTime() + ".log"
        self.POSTDIRBASE_FROM = self.PROJECTDIR_DOCPROCESSING + "/data/weedingDocumentsDeleteOnServer"
        self.POSTDIRBASE_TO = self.PROJECTDIR_DOCPROCESSING + "/data/outputfilesWeededProcess"
        self.ARCHIVE_DIR = self.PROJECTDIR_DOCPROCESSING + "/data/archiveFilesFrequent"
        self.POST_URL = 'curl {0}?commit=false -H "Content-Type: text/xml" --data-binary @{1}'
        self.POST_URL_SUBPROCESS = '{0}?commit=false'
        self.POST_COMMIT = 'curl {0}?stream.body=%3Ccommit/%3E'

        self.PROJECTDIR_DOCPROCESSING = "/swissbib_index/solrDocumentProcessing/MarcToSolr"
        self.PROJECTDIR_DOCPROCESSING_MF = "/swissbib_index/solrDocumentProcessing/MarcToSolr"
        self.POSTCLIENTDIR = self.PROJECTDIR_DOCPROCESSING_MF +  "/dist/postclient"

        self.METAFACTURE_HOME = self.POSTCLIENTDIR
        self.SOLR7_INDEX_LOGPATH = self.POSTCLIENTDIR + "/log"



    def preChecks(self,options):
        self.writeLogMessage("in preChecks..")

        if not os.path.exists(self.PROJECTDIR_DOCPROCESSING):
            raise Exception("directory " + self.PROJECTDIR_DOCPROCESSING  + " is missing")

        if not os.path.exists(self.PROJECTDIR_DOCPREPROCESSING):
            raise Exception("directory " + self.PROJECTDIR_DOCPREPROCESSING  + " is missing")


        self.INPUT_DIR = options.inputDir
        self.writeLogMessage("base input directory: " + self.INPUT_DIR)

        self.INDEX_CONFIG = options.configIndex
        self.writeLogMessage("index config: " + self.INDEX_CONFIG)


        if not os.path.exists(self.POSTDIRBASE_TO):
            os.system("mkdir -p " +  self.POSTDIRBASE_TO)

        if not os.path.exists(self.LOGDIR):
            os.system("mkdir -p " +  self.LOGDIR)


        """
            still todo

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
        """



    def moveDocuments(self):
        self.writeLogMessage("moving documents...")
        os.system("mv " + self.POSTDIRBASE_FROM + os.sep  + "*" +  " " + self.POSTDIRBASE_TO)


    def post2SOLR7MF(self):
        self.writeLogMessage(self.currentDateTime() + " documents are now posted to SOLR 7 cluster...")


        runIndexerClientMF = "export METAFACTURE_HOME={MF_HOME}; cd {MF_HOME}; {MF_HOME}/sb_post2solr.sh -i {INPUT_DIR} -c {INDEX_CONFIG}".format(
            MF_HOME=self.METAFACTURE_HOME,INPUT_DIR=self.INPUT_DIR, INDEX_CONFIG=self.INDEX_CONFIG
        )

        self.writeLogMessage("call for indexerclient: " + runIndexerClientMF)
        os.system(runIndexerClientMF)
        self.writeLogMessage(self.currentDateTime() + " finished posting documents  to SOLR 7 cluster...")


    def archiveAndZip(self):
        self.writeLogMessage(" documents are now archived...")
        os.system("tar zcf " + self.ARCHIVE_DIR + os.sep + "PostedWeededSolrDocuments" + self.currentDateTime() + "tar.gz " + self.POSTDIRBASE_TO + os.sep + "* --remove-files")




    def __initialize(self):
        pass


    def currentDateTime(self,onlyDate = False, wait = False):
        if wait:
            time.sleep(5)

        if onlyDate:
            return datetime.now().strftime("%Y%m%d")
        else:
            return datetime.now().strftime("%Y%m%d%H%M%S")



    def writeLogMessage(self, message):
        self.LOGFILE.write("-->>  " + message  + "   <<----\n" )
        self.LOGFILE.flush()

    def closeResources(self):

        if not self.LOGFILE is None:
            self.LOGFILE.write("closing logfile : {0} \n".format(self.currentDateTime()))
            self.LOGFILE.flush()
            self.LOGFILE.close()





if __name__ == '__main__':

    usage = "usage: %prog -i [INPUTDIR]  "

    #parser = OptionParser(usage=usage)
    parser = OptionParser(usage=usage)

    parser.add_option("-i", "--inputDir", dest="inputDir",
                      help="[optional] base input dir which contains documents to be indexed ",
                      default='/swissbib_index/solrDocumentProcessing/MarcToSolr/data/outputfilesWeededProcess')

    parser.add_option("-c", "--configIndex", dest="configIndex",
                      help="[mandatory] index config properties ",
                      default='../app.c1c2.properties')


    (options, args) = parser.parse_args()

    frequentPost = None
    #subprocess.call()
    #http://www.python-kurs.eu/os_modul_shell.php
    #https://docs.python.org/2/library/subprocess.html
    #http://stackoverflow.com/questions/4514751/pipe-subprocess-standard-output-to-a-variable
    #http://www.cyberciti.biz/faq/python-run-external-command-and-get-output/
    #http://eyalarubas.com/python-subproc-nonblock.html
    #http://www.daniweb.com/software-development/python/threads/281000/using-the-bash-output-in-python
    #https://cwiki.apache.org/confluence/display/solr/Uploading+Data+with+Index+Handlers
    #-> post in batch mit files!
    try:

        frequentPost = Post2SolrFrequent()
        frequentPost.writeLogMessage("pre checks: " + frequentPost.currentDateTime())
        frequentPost.preChecks(options)
        frequentPost.writeLogMessage("moving documents " + frequentPost.currentDateTime())
        frequentPost.moveDocuments()
        frequentPost.writeLogMessage("post 2 SOLR7: " + frequentPost.currentDateTime())
        frequentPost.post2SOLR7MF()

        frequentPost.writeLogMessage("archiving documents: " + frequentPost.currentDateTime())
        frequentPost.archiveAndZip()

        frequentPost.writeLogMessage("post to SOLR for weeded documents has finished: " + frequentPost.currentDateTime())


    except Exception as argsError:
        if not frequentPost is None:
            frequentPost.writeLogMessage("Exception occured in control script: {0} ".format(argsError))

    finally:
        if not frequentPost is None:
            frequentPost.writeLogMessage("process finished at: {0} ".format(frequentPost.currentDateTime()))
            frequentPost.closeResources()



