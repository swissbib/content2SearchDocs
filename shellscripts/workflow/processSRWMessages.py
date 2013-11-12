
__author__ = 'swissbib - UB Basel, Switzerland, Guenter Hipler'
__copyright__ = "Copyright 2013, swissbib project"
__license__ = "??"
__version__ = "0.9"
__maintainer__ = "Guenter Hipler"
__email__ = "guenter.hipler@unibas.ch"
__status__ = "in development"
__description__ = """
                process SRW messages to Search engine documents
                """


import re, os, time, glob
from datetime import datetime


class ProcessSrwMessages:


    def __init__(self):

        self.JAVA_PROGRAM_CREATING_SEARCHDOCS = "xml2SearchEngineDoc.jar"


        self.PROJECTDIR_DOCPROCESSING = "/swissbib_index/solrDocumentProcessing/MarcToSolr"

        self.PROJECTDIR_DOCPREPROCESSING = "/swissbib_index/solrDocumentProcessing/FrequentInitialPreProcessing"

        self.UPDATEDIR = self.PROJECTDIR_DOCPREPROCESSING + "/data/update"

        self.UPDATEDIRLOAD= self.UPDATEDIR + "/loadUpdate"
        self.DELETEDIRLOAD= self.UPDATEDIR + "/loadDelete"
        self.LOGDIR= self.PROJECTDIR_DOCPREPROCESSING + "/log/update"
        self.ARCHIVEDIR= self.UPDATEDIR + "/archive"
        self.INPUTPATH = self.PROJECTDIR_DOCPROCESSING + "/data/inputfilesFrequent"
        self.OUTDIRBASE = self.PROJECTDIR_DOCPROCESSING + "/data/outputfilesFrequent"
        self.TRANSDIR = self.PROJECTDIR_DOCPREPROCESSING + "/feed"
        self.LOGCONFIGmarc2SOLR = "marcxml2solrlog4j_1.xml"
        self.CONFFILE=self.PROJECTDIR_DOCPROCESSING + "/dist/config.properties"
        self.XSLTPATH = self.PROJECTDIR_DOCPROCESSING  + "/xslt"
        self.MARC2SOLRJAR= self.PROJECTDIR_DOCPROCESSING + "/dist/" + self.JAVA_PROGRAM_CREATING_SEARCHDOCS
        self.CATCHER_WEBAPP_PATH = self.PROJECTDIR_DOCPREPROCESSING +  "/catcher/tomcat/bin"


        self.__initialize()

        self.LOGFILE = open (self.LOGDIR + os.sep + self.currentDateTime() + ".update.process.log","w")

        self.LOGFILE.write("\n**** Process of SRW Message-Updates started at: {0} **************** \n".format(self.currentDateTime()))



    def closeResources(self):

        if not self.LOGFILE is None:
            self.LOGFILE.write("closing logfile : {0} \n".format(self.currentDateTime()))

            self.LOGFILE.flush()
            self.LOGFILE.close()


    def __initialize(self):
        if not os.path.exists(self.PROJECTDIR_DOCPREPROCESSING):
            raise Exception("base Dir docprocessing " + self.PROJECTDIR_DOCPREPROCESSING  + " is missing")

        if not os.path.exists(self.UPDATEDIRLOAD):
            raise Exception("load directory for update messages  " + self.UPDATEDIRLOAD  + " is missing")

        if not os.path.exists(self.DELETEDIRLOAD):
            raise Exception("load directory for delete messages  " + self.DELETEDIRLOAD  + " is missing")


        if not os.path.exists(self.LOGDIR):
            os.system("mkdir -p " +  self.LOGDIR)

        if not os.path.exists(self.ARCHIVEDIR):
            os.system("mkdir -p " +  self.ARCHIVEDIR)


        if not os.path.exists(self.INPUTPATH):
            os.system("mkdir -p " +  self.INPUTPATH)


        if not os.path.exists(self.OUTDIRBASE):
            os.system("mkdir -p " +  self.OUTDIRBASE)



    def checkRequiredArguments(self, opts, parser):

        missing_options = []
        for option in parser.option_list:
            if re.match(r'^\[REQUIRED\]', option.help) and eval('opts.' + option.dest) == None:
                missing_options.extend(option._long_opts)
        if len(missing_options) > 0:
            parser.error('Missing REQUIRED parameters: ' + str(missing_options))
            raise Exception()


    def isOptionsValid(self, givenOpts):

        #manadatory_options = ["upDir","delDir", "confFile"]
        manadatory_options = ["upDir","delDir"]

        for tOption in manadatory_options:
            optionValue = eval("givenOpts." + tOption)

            if not os.path.exists(optionValue):
                raise Exception("path or file for given option " + tOption  + " "  + optionValue + " is missing")
            else:
                self.__dict__[tOption] = optionValue


    def shutdownMessageCatcher(self):
        #startResult = os.popen('/opt/swissbib/tools/java.tools/tomcat7-axis2/bin/shutdown.sh -force').read()
        startResult = os.popen( self.CATCHER_WEBAPP_PATH + os.sep + 'shutdown.sh -force').read()
        #environment variables in shell
        #http://stackoverflow.com/questions/8365394/set-environment-variable-in-python-script
        #do something with result
        #make a rest to close all open resources
        time.sleep(5)



    def startMessageCatcher(self):
        #shutDownResult = os.popen('/opt/swissbib/tools/java.tools/tomcat7-axis2/bin/startup.sh').read()
        shutDownResult = os.popen(self.CATCHER_WEBAPP_PATH + os.sep + 'startup.sh').read()
        #do something with result




    def moveSRWmessagesToLoadDirs(self):

        #move update messages
        for fname in os.listdir(self.upDir):
            os.system("mv " + self.upDir + os.sep  + fname +  " " + self.UPDATEDIRLOAD)

        #move delete messages
        #os.system("mv " + self.delDir  + "/*"  + " " +   self.DELETEDIRLOAD)
        #we cannot use just mv " + self.delDir  + "/*" because we get an exception too many arguments
        #this method is a little bit slower but more secure
        for fname in os.listdir(self.delDir):
            os.system("mv " + self.delDir + os.sep  + fname +  " " + self.DELETEDIRLOAD)



    def processDeleteMessages(self):

        #required format for delete file
        #<?xml version="1.0" encoding="UTF-8"?>
        #<delete>
        #<id>217364640</id>
        #...
        #</delete>


        numberOfFiles = len(glob.glob(self.DELETEDIRLOAD + os.sep + "REQ_*.xml"))
        if numberOfFiles > 0:

            self.writeLogMessage("{0} messages to delete search docs".format(numberOfFiles))

            OUTPUT_SUBDIR_DELETE = self.OUTDIRBASE + os.sep + self.currentDateTime() + "_AIdsToDelete"

            os.system("mkdir -p " + OUTPUT_SUBDIR_DELETE)

            delete_File = OUTPUT_SUBDIR_DELETE + os.sep + "idsToDelete." + self.currentDateTime(wait=True) + ".xml"
            hDelete_File =  open(delete_File,"w")
            hDelete_File.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + os.linesep)
            hDelete_File.write("<delete>" + os.linesep)


            pPattern = re.compile("REQ_(.*?)\.xml")
            #Pattern of File REQ_123456.xml
            for fname in os.listdir(self.DELETEDIRLOAD):
                mFilePattern = pPattern.search(fname)
                if mFilePattern:
                    docId = mFilePattern.group(1)
                    hDelete_File.write("<id>" + docId + "</id>" + os.linesep)
                    #os.remove(self.DELETEDIRLOAD + os.sep + fname)

                else:
                    self.writeLogMessage("wrong file pattern {0} - could not be used to delete a search doc".format(fname))

            hDelete_File.write("</delete>" + os.linesep)

            hDelete_File.flush()
            hDelete_File.close()

            #see remark in processUpdateMessages
            deleteTarFile = self.currentDateTime() + ".deleteMessages.tar.gz "
            cmd = "tar cfz " + self.UPDATEDIR + os.sep + deleteTarFile +  " " + self.DELETEDIRLOAD  + " --remove-files"
            os.system(cmd)
            os.system("mv " + self.UPDATEDIR + os.sep + deleteTarFile + self.ARCHIVEDIR)
            os.system("mkdir -p " + self.DELETEDIRLOAD)



    def processUpdateMessages(self):

        self.writeLogMessage("starting processUpdateMessages at: {0}".format(self.currentDateTime()))

        stringCurrentDate = self.currentDateTime(wait=True)
        ALL_UPDATES_FILE_BASE = stringCurrentDate +  "_Bulkupdate_2SearchDocs"
        ALL_UPDATES_FILE= ALL_UPDATES_FILE_BASE + ".xml"
        ALL_UPDATES_FILE_WITH_PATH = self.TRANSDIR + os.sep + ALL_UPDATES_FILE
        hALL_UPDATES_FILE =  open(ALL_UPDATES_FILE_WITH_PATH,"w")

        os.system("cd " + self.UPDATEDIRLOAD)

        numberOfFiles = len(glob.glob(self.UPDATEDIRLOAD + os.sep + "REQ_*.xml"))
        self.writeLogMessage("{0} messages to update search docs".format(numberOfFiles))

        self.writeLogMessage("files with update messages:")


        for fname in os.listdir(self.UPDATEDIRLOAD):

            self.writeLogMessage("update file {0} ".format(fname))

            with open(self.UPDATEDIRLOAD + os.sep +  fname,"r") as hUpdateFile:
                contentUpdateFile = hUpdateFile.read()
                hUpdateFile.close()
                hALL_UPDATES_FILE.write(contentUpdateFile + os.linesep)
                # at the moment delete file (better archive it)
                #os.remove(self.UPDATEDIRLOAD + os.sep + fname)


        self.LOGFILE.flush()

        #seems to be a little bit cumbersome but we get a too many argument exception trying to include the update messages into a tar file using a file pattern
        #therefor I include the whole LoadDir into the zipped tar file and create then a new directory because of the remove-files parameter which removes obviously the whole load Dir
        updateTarFile = self.currentDateTime() + ".updateMessages.tar.gz "
        cmd = "tar cfz " + self.UPDATEDIR + os.sep + updateTarFile +  " " + self.UPDATEDIRLOAD  + " --remove-files"
        os.system(cmd)
        os.system("mv " + self.UPDATEDIR + os.sep + updateTarFile + self.ARCHIVEDIR)
        os.system("mkdir -p " + self.UPDATEDIRLOAD)


        hALL_UPDATES_FILE.flush()
        hALL_UPDATES_FILE.close()

        OUTPUT_SUBDIR_DETAIL =   self.OUTDIRBASE + os.sep + ALL_UPDATES_FILE_BASE

        os.system("mkdir -p " + OUTPUT_SUBDIR_DETAIL)


        self.writeLogMessage("Java program for creating SearchDocs {0} is going to be called at: {1}".format(self.JAVA_PROGRAM_CREATING_SEARCHDOCS, self.currentDateTime()))

        cmdline =  "java -Xms2048m -Xmx2048m"                                                   \
            + " -Dlog4j.configuration=" + self.LOGCONFIGmarc2SOLR                               \
            + " -DLOGDEDUPLICATION=false"                                                       \
            + " -DINPUT.FILE="  + ALL_UPDATES_FILE_WITH_PATH                                    \
            + " -DCONF.ADDITIONAL.PROPS.FILE=" + self.CONFFILE                                  \
            + " -DOUTPUT.DIR=" + OUTPUT_SUBDIR_DETAIL                                           \
            + " -DTARGET.SEARCHENGINE=org.swissbib.documentprocessing.solr.XML2SOLRDocEngine"   \
            + " -DXPATH.DIR=" + self.XSLTPATH                                                   \
            + " -DSKIPRECORDS=false"                                                            \
            + " -jar " + self.MARC2SOLRJAR


        #run Java program for creation of SearchEngine documents
        #todo: look for better communication with subprocess
        os.popen(cmdline)

        self.writeLogMessage("Java program for creating SearchDocs has finished at: {0}".format( self.currentDateTime()))


        os.system("mv " + ALL_UPDATES_FILE_WITH_PATH + " " + self.ARCHIVEDIR)
        os.system("gzip " + self.ARCHIVEDIR + os.sep + ALL_UPDATES_FILE)



    def currentDateTime(self,onlyDate = False, wait = False):

        if wait:
            time.sleep(5)

        if onlyDate:
            return datetime.now().strftime("%Y%m%d")
        else:
            return datetime.now().strftime("%Y%m%d%H%M%S")

    def writeLogMessage(self, message):
        self.LOGFILE.write("-->>  " + message  + "   <<----\n" )




if __name__ == '__main__':



    from optparse import OptionParser

    #usage = "usage: %prog -u [updateDir] -d [deleteDir] -c [confFile] >> [path-to-log-file][name].log 2>&1"
    usage = "usage: %prog -u [updateDir] -d [deleteDir] "

    #parser = OptionParser(usage=usage)
    parser = OptionParser(usage=usage)
    parser.add_option("-u", "--updir", dest="upDir",
                      help="[REQUIRED] path to directory for update messages")

    parser.add_option("-d", "--deldir", dest="delDir",
                      help="[REQUIRED] path to directory directory for delete messages")
    #conf-file is defined in script
    #parser.add_option("-c", "--conf", dest="confFile",
    #                  help="[REQUIRED] further configuration file")



    (options, args) = parser.parse_args()

    srwMessages = None
    try:
        srwMessages = ProcessSrwMessages()

        srwMessages.checkRequiredArguments(options,parser)

        srwMessages.isOptionsValid(options)

        srwMessages.shutdownMessageCatcher()

        srwMessages.moveSRWmessagesToLoadDirs()

        srwMessages.startMessageCatcher()

        srwMessages.processDeleteMessages()

        srwMessages.processUpdateMessages()


    except Exception as argsError:
        if not srwMessages is None:
            srwMessages.writeLogMessage("Exception occured in control script: {0} ".format(argsError))

    finally:
        if not srwMessages is None:
            srwMessages.writeLogMessage("process finished at: {0} ".format(srwMessages.currentDateTime()))
            srwMessages.closeResources()



