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
__version__ = "0.9"
__maintainer__ = 'Guenter Hipler'
__email__ = 'guenter.hipler@unibas.ch'
__status__ = "in development"
__description__ = """
                    script to control the posting of Search documents (at the moment only SOLR)
                     which are the outcome of the regular processing of updated content from the data-hub
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
        self.LOGFILE = open (self.LOGDIR + os.sep + self.currentDateTime() + ".post2SolrFrequentDocs.log","a")
        self.LOGSPOST2SOLR = self.LOGDIR + "/post2SOLR" +  self.currentDateTime() + ".log"
        self.POSTDIRBASE_FROM = self.PROJECTDIR_DOCPROCESSING + "/data/outputfilesFrequent"
        self.POSTDIRBASE_TO = self.PROJECTDIR_DOCPROCESSING + "/data/outputfilesFrequentProcess"
        self.ARCHIVE_DIR = self.PROJECTDIR_DOCPROCESSING + "/data/archiveFilesFrequent"
        self.SOLR7_CLIENT_DIR = self.PROJECTDIR_DOCPROCESSING + "/distsolr7"
        self.SOLR7_INDEX_LOGPATH = self.SOLR7_CLIENT_DIR + "/indexerlogs"
        self.SOLR7_PROPERTIES = self.SOLR7_CLIENT_DIR + "/app.properties"
        #self.POST_URL = 'curl http://sb-s7.swissbib.unibas.ch:8080/solr/sb-biblio/update?commit=false -H "Content-Type: text/xml" --data-binary @{0}'
        self.POST_URL = 'curl {0}?commit=false -H "Content-Type: text/xml" --data-binary @{1}'
        #self.POST_URL_SUBPROCESS = 'http://sb-s7.swissbib.unibas.ch:8080/solr/sb-biblio/update?commit=false'
        self.POST_URL_SUBPROCESS = '{0}?commit=false'
        #self.POST_COMMIT = 'curl http://sb-s7.swissbib.unibas.ch:8080/solr/sb-biblio/update?stream.body=%3Ccommit/%3E'
        self.POST_COMMIT = 'curl {0}?stream.body=%3Ccommit/%3E'
        #self.DEFAULT_STDOUT = sys.stdout
        #self.DEFAULT_STDERR = sys.stderr
        #sys.stdout = self.LOGFILE
        #sys.stderr = self.LOGFILE
        self.METAFACTURE_HOME = self.SOLR7_CLIENT_DIR






    def preChecks(self,options):
        self.writeLogMessage("in preChecks..")

        if not os.path.exists(self.PROJECTDIR_DOCPROCESSING):
            raise Exception("directory " + self.PROJECTDIR_DOCPROCESSING  + " is missing")

        if not os.path.exists(self.PROJECTDIR_DOCPREPROCESSING):
            raise Exception("directory " + self.PROJECTDIR_DOCPREPROCESSING  + " is missing")

        if options.indexingURL is None:
            self.writeLogMessage("no indexer URL given..")
            print "URL for indexer host is missing"
            print "<usage(e.g.): python post2SolrFrequent.py -shttp://sb-s7.swissbib.unibas.ch:8080/solr/sb-biblio/update  > "
            sys.exit(0)
        else:
            self.INDEXING_MASTER_URL = options.indexingURL
            #self.POST_URL = self.POST_URL.format(self.INDEXING_MASTER_URL)
            #self.POST_URL_SUBPROCESS = self.POST_URL_SUBPROCESS.format(self.INDEXING_MASTER_URL)
            #self.POST_COMMIT = self.POST_COMMIT.format(self.INDEXING_MASTER_URL)

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

    def post2SOLR(self):
        self.writeLogMessage("documents are now posted to SOLR...")

        for subDir in sorted(os.listdir(self.POSTDIRBASE_TO)):
            self.writeLogMessage("processing documents in subdir: " + subDir)
            patternAbsolutePathSubDir = self.POSTDIRBASE_TO + os.sep + subDir

            for singleFile in sorted(os.listdir(patternAbsolutePathSubDir)):

                self.__sendUseProc(patternAbsolutePathSubDir,singleFile)
                #would be better - more evaluation necessary
                #self.__sendUseSubProc(patternAbsolutePathSubDir,singleFile)

            self.writeLogMessage("content of sub-dir was posted - now commit the updates")
            pipe = os.popen(self.POST_COMMIT.format(self.INDEXING_MASTER_URL))
            rc = pipe.close()
            if rc is not None and rc >> 8:
                self.writeLogMessage("errors while committing posts")




    def post2SOLR7(self):
        self.writeLogMessage(self.currentDateTime() + " documents are now posted to SOLR 7 cluster...")

        os.system("cd " + self.SOLR7_CLIENT_DIR)

        runIndexerclient = 'java -jar -Dlog4j.configurationFile={LOG4J}   -Dlog.path.clientIndexer={LOGPATH} -Dapp.properties={APPPROPS}   {JARFILE}'.format(
            LOG4J='log4j.xml',
            LOGPATH=self.SOLR7_INDEX_LOGPATH,
            APPPROPS=self.SOLR7_PROPERTIES,
            JARFILE=self.SOLR7_CLIENT_DIR + '/indexerSolrClient-1.0-SNAPSHOT-plugin.jar'
            )



        self.writeLogMessage("call for indexerclient: " + runIndexerclient)

        os.system(runIndexerclient)

        self.writeLogMessage(self.currentDateTime() + " finished posting documents  to SOLR 7 cluster...")


    def post2SOLR7MF(self):
        self.writeLogMessage(self.currentDateTime() + " documents are now posted to SOLR 7 cluster...")


        runIndexerClientMF = "export METAFACTURE_HOME={MF_HOME}; cd {MF_HOME}; {MF_HOME}/flux.sh {MF_HOME}/flux/indexsolr.flux ".format(
            MF_HOME=self.METAFACTURE_HOME,
        )

        self.writeLogMessage("call for indexerclient: " + runIndexerClientMF)
        os.system(runIndexerClientMF)
        self.writeLogMessage(self.currentDateTime() + " finished posting documents  to SOLR 7 cluster...")




    def archiveAndZip(self):
        self.writeLogMessage(" documents are now archived...")
        os.system("tar zcf " + self.ARCHIVE_DIR + os.sep + "PostedSolrDocuments" + self.currentDateTime() + "tar.gz " + self.POSTDIRBASE_TO + os.sep + "* --remove-files")




    def __initialize(self):
        pass

    def __sendUseSubProc(self,path=None ,file=None):
        if (path is not None and file is not None):
            #proc = subprocess.Popen(['curl','http://sb-s7.swissbib.unibas.ch:8080/solr/sb-biblio/update?commit=false'
            #                        '-H "Content-Type: text/xml',
            #                         '--data-binary',
            #                         '@/swissbib_index/solrDocumentProcessing/MarcToSolr/data/outputfilesFrequentProcess/123/solrout5.xml'],
            #                        stdout=subprocess.PIPE,stderr=subprocess.PIPE)
            #doesn't work - why??
            #see also: https://docs.python.org/2/library/subprocess.html#replacing-os-popen-os-popen2-os-popen3
            #!!!
            #use pycurl: http://pycurl.sourceforge.net/doc/install.html#easy-install-pip
            #example: https://github.com/pycurl/pycurl/blob/master/examples/file_upload.py
            #!!!
            url = self.POST_URL_SUBPROCESS.format(self.INDEXING_MASTER_URL)
            filename = path + os.sep + file
            request = 'curl ' + url +' -H "Content-Type: text/xml" --data-binary \@' + filename
            #proc = subprocess.Popen(request,
            #                        stdout=subprocess.PIPE,stderr=subprocess.PIPE)
            proc = subprocess.Popen(request, stdout=subprocess.PIPE).communicate()[0]
            #proc = subprocess.Popen(['curl',url,
            #                        '-H "Content-Type: text/xml',
            #                         '--data-binary',
            #                         '@' + filename],
            #                        stdout=subprocess.PIPE,stderr=subprocess.PIPE)

            output = proc.stdout.read()
            err = proc.stderr.read()
            self.writeLogMessage(">committed file: " + file + "< ")
            self.writeLogMessage(">stdout / stderr" )
            self.writeLogMessage(output)
            self.writeLogMessage(err)

    def __sendUseProc(self,path=None ,file=None):

        if (path is not None and file is not None):
            cmdline = self.POST_URL.format(self.INDEXING_MASTER_URL, path + os.sep + file)
            self.writeLogMessage(">>sending file: " + file + " <<")
            pipe =  os.popen(cmdline)
            rc = pipe.close()
            if rc is not None and rc >> 8:
                self.writeLogMessage("errors while sending content to SearchServer")


    def __sendUseJava(self,path=None, file=None):
        pass
        #don't use this
        #cmdline =  "java -Xms2048m -Xmx2048m"                               \
        #    + " -Durl=" + self.INDEXING_MASTER_URL                          \
        #    + " -Dcommit=no"                                                \
        #    + " -jar " + self.POSTJAR + " " + patternAbsolutePathSubDir

        #cmdline =  "java -Xms2048m -Xmx2048m"                               \
        #    + " -Durl=" + self.INDEXING_MASTER_URL                          \
        #    + " -Dcommit=yes"                                                \
        #    + " -jar " + self.POSTJAR





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

    usage = "usage: %prog -s [INDEXINGMASTERURL]  "

    #parser = OptionParser(usage=usage)
    parser = OptionParser(usage=usage)
    parser.add_option("-s", "--indexerURL", dest="indexingURL",
                      help="[REQUIRED] url of the indexer host ")

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
        frequentPost.writeLogMessage("call prechecks: " + frequentPost.currentDateTime())
        frequentPost.preChecks(options)
        frequentPost.writeLogMessage("move documents: " + frequentPost.currentDateTime())
        frequentPost.moveDocuments()
        frequentPost.writeLogMessage("post 2 SOLR4: " + frequentPost.currentDateTime())
        frequentPost.post2SOLR()
        frequentPost.writeLogMessage("post 2 SOLR7: " + frequentPost.currentDateTime())
        frequentPost.post2SOLR7MF()
        frequentPost.writeLogMessage("now archiving starts: " + frequentPost.currentDateTime())
        frequentPost.archiveAndZip()

        frequentPost.writeLogMessage("post to SOLR has finished: " + frequentPost.currentDateTime())


    except Exception as argsError:
        if not frequentPost is None:
            frequentPost.writeLogMessage("Exception occured in control script: {0} ".format(argsError))

    finally:
        if not frequentPost is None:
            frequentPost.writeLogMessage("process finished at: {0} ".format(frequentPost.currentDateTime()))
            frequentPost.closeResources()



