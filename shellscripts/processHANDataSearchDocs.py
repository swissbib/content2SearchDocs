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
__version__ = "0.8"
__maintainer__ = 'Guenter Hipler'
__email__ = 'guenter.hipler@unibas.ch'
__status__ = "in development"
__description__ = """
                    script to prepare bibliographic archive data (HAN) for SOLR search documents 
                    finished processed SOLR documents are then send to the Search targets
                    old documents are deleted before
                """


from os import path, listdir
from argparse import ArgumentParser
import os,sys, time, subprocess
from datetime import datetime
import shutil


# ssh -L 29017:localhost:29017 hipler@sb-udb7.swissbib.unibas.ch
#ssh -L 2000:localhost:3306 hipler@sb-udb4.swissbib.unibas.ch

class ProcessHANForSearchDocs:

    def __init__(self, args):

        self.SF = args.solrfrequent
        self.M2S = args.marc2solr


        #self.urlGreen = args.green
        #self.urlOrange = args.orange
        self.urlGreenCommit = []
        self.urlOrangeCommit = []
        self.__createClusterURL(args)
        self.greenInput = args.greenInput
        self.orangeInput = args.orangeInput

        self.greenZKConfig = args.zgreen
        self.orangeZKConfig = args.zorange

        self.M2SarchiveFilesArchivaldata =  self.M2S + '/data/archivaldata_archive'
        self.M2SoutfilesArchivalData = self.M2S + '/data/outputfiles_archivaldata'
        self.SFarchiveFilesFrequent = self.SF +  '/data/archivaldata_archive'
        self.SFrawFromHAN =  self.SF +  '/data/format_archivaldata'
        self.SFrawFromHANProcess = self.SF +  '/data/format_archivaldata_process'
        self.binDir = self.M2S +  '/dist'
        self.binPostDir = self.binDir + os.sep + "postclient"
        self.postScript = self.binPostDir + os.sep + "sb_post2solr.sh"

        self.METAFACTURE_HOME = self.binPostDir


        self.bashScriptProcessing = 'sb_marc2solr_archivaldata.sh'
        self.hanDeleteQuery = 'commit=true -H "Content-Type: text/xml" -d \'<delete><query>ctrlnum:HAN*</query></delete>\''
        self.logDir = '/swissbib_index/solrDocumentProcessing/MarcToSolr/data/log'
        self.logfileName = "".join([self.logDir,"han2solr.log"])
        self.LOGFILE = open(self.logDir + os.sep +  "han2Solr.log", "a")
        #self.PROJECTDIR_DOCPROCESSING = "/swissbib_index/solrDocumentProcessing/MarcToSolr"
        self.JAVA_PROGRAM_CREATING_SEARCHDOCS = "content2SearchDocs-0.8-SNAPSHOT.jar"
        self.LOGCONFIGmarc2SOLR = "marcxml2solrlog4j_1.xml"
        self.CONFFILE=self.binDir + "/configArchivaldata.properties"
        self.XSLTPATH = self.M2S  + "/xslt" + "###" + self.M2S + "/xsltskipRecords"
        self.MARC2SOLRJAR = self.binDir + os.sep +  self.JAVA_PROGRAM_CREATING_SEARCHDOCS

        #self.POST_URL_NO_COMMIT = '{0}?commit=false -H "Content-Type: text/xml" --data-binary @{1}'
        self.POST_URL_NO_COMMIT = '{0}?commit=false'
        self.POST_COMMIT = '{0}?stream.body=%3Ccommit/%3E'

        self.__initialize()



    def __initialize(self):

        self.checkfileexists([self.M2S])
        self.createIfDirNotexists([self.M2SarchiveFilesArchivaldata,
                                   self.M2SoutfilesArchivalData,
                                   self.SFarchiveFilesFrequent,
                                   self.SFrawFromHAN,
                                   self.binDir,
                                   self.logDir,
                                   self.SFrawFromHANProcess])
        #logging framework doesn't work at the moment - don't know why
        #logging.basicConfig( filename="test.log", format='%(asctime)s %(message)s', level=logging.INFO,
        #                    filemode='a')


    def __createClusterURL(self,args):
         self.urlGreen = args.green.split("###")
         self.urlOrange = args.orange.split("###")

         for url in self.urlGreen:
             self.urlGreenCommit.append( url + "?commit=true")

         for url in self.urlOrange:
             self.urlOrangeCommit.append(url + "?commit=true")



    def checkfileexists(self,filelist):
        """
        Checks if files in given list exist in file system. Quits if errors are found
        :param filelist: List of files to check
        :return: None
        """
        for sf in filelist:
            logmsg = 'Checking if file ' + sf + ' exists... '
            if not path.exists(sf):
                self.writeLog(logmsg)
                sys.exit(1)
            else:
                self.writeLog(logmsg + ' OK')

    def cleanDirectory(self, dirToclean):
        if len(listdir(dirToclean)) > 0:
            for f in listdir(dirToclean):
                if os.path.isdir(path.join(dirToclean,f)):
                    shutil.rmtree(path.join(dirToclean,f))
                if os.path.isfile(path.join(dirToclean,f)):
                    os.remove(path.join(dirToclean,f))


    def cleanDirectories(self):

        self.cleanDirectory(self.M2SarchiveFilesArchivaldata)
        self.cleanDirectory(self.SFrawFromHANProcess)

        if path.exists(self.M2SoutfilesArchivalData + os.sep + "gruen_marcxml"):
            subroutine(["mv", self.M2SoutfilesArchivalData + os.sep + "gruen_marcxml",
                        self.M2SarchiveFilesArchivaldata])

        if path.exists(self.M2SoutfilesArchivalData + os.sep + "orange_marcxml"):
            subroutine(["mv", self.M2SoutfilesArchivalData + os.sep + "orange_marcxml",
                        self.M2SarchiveFilesArchivaldata])

    def deleteHANDocsOnIndices(self):

        for clusterURL in self.urlGreenCommit:
            subroutine(["curl",
                        "-H",
                        'Content-Type: text/xml',
                        "-d",
                        '<delete><query>ctrlnum:HAN*</query></delete>',
                        clusterURL],self)

        for clusterURL in self.urlOrangeCommit:
            subroutine(["curl",
                        "-H",
                        'Content-Type: text/xml',
                        "-d",
                        '<delete><query>ctrlnum:HAN*</query></delete>',
                        clusterURL],self)


    def processDocuments(self):
        self.writeLog("starting processUpdateMessages at: {0}".format(self.currentDateTime()))
        if os.path.isfile(self.SFrawFromHANProcess + os.sep + "gruen_marcxml.format.xml"):
            self.processFile("gruen_marcxml.format.xml","gruen_marcxml")
        if os.path.isfile(self.SFrawFromHANProcess + os.sep + "orange_marcxml.format.xml"):
            self.processFile("orange_marcxml.format.xml","orange_marcxml")


    def sendToSearchServer(self):

        #index green
        self.post2SOLR(self.greenInput,self.greenZKConfig)

        self.post2SOLR(self.orangeInput,self.orangeZKConfig)





    def processFile(self,hanFileName, nameSubdir):
        OUTPUT_SUBDIR_DETAIL =   self.M2SoutfilesArchivalData + os.sep + nameSubdir

        if not os.path.isdir(OUTPUT_SUBDIR_DETAIL):
            subroutine(["mkdir", "-p", OUTPUT_SUBDIR_DETAIL])

        self.writeLog("Java program for creating SearchDocs {0} is going to be called at: {1}".format(self.JAVA_PROGRAM_CREATING_SEARCHDOCS, self.currentDateTime()))


        #run Java program for creation of SearchEngine documents
        subroutine(["java", "-Xms2048m",
                    "-Xmx2048m","-Dlog4j.configuration=" + self.LOGCONFIGmarc2SOLR,
                    "-DLOGDEDUPLICATION=false",
                    "-DINPUT.FILE=" + self.SFrawFromHANProcess + os.sep + hanFileName,
                    "-DCONF.ADDITIONAL.PROPS.FILE=" + self.CONFFILE,
                    "-DOUTPUT.DIR=" + OUTPUT_SUBDIR_DETAIL,
                    "-DTARGET.SEARCHENGINE=org.swissbib.documentprocessing.solr.XML2SOLRDocEngine",
                    "-DXPATH.DIR=" + self.XSLTPATH,
                    "-DSKIPRECORDS=false",
                    "-jar", self.MARC2SOLRJAR],self)

        self.writeLog("Java program for creating SearchDocs has finished at: {0}".format( self.currentDateTime()))


    def post2SOLR(self, inputDir, config):

        self.writeLog("documents are now posted to SOLR...")
        self.writeLog("inoutDir: {0} config: {1}".format(inputDir,config))

        runIndexerClientMF = "export METAFACTURE_HOME={MF_HOME}; cd {MF_HOME}; {POSTSCRIPT} -i {INPUT_DIR} -c {INDEX_CONFIG}".format(
            MF_HOME=self.METAFACTURE_HOME,
            POSTSCRIPT=self.postScript,
            INPUT_DIR=inputDir, INDEX_CONFIG=config
        )
        os.system(runIndexerClientMF)

    def archiveCurrentHANcontent(self):
        for f in os.listdir(self.SFrawFromHAN):
                subroutine(["mv",
                            self.SFrawFromHAN + os.sep + f,
                            self.SFarchiveFilesFrequent],
                           self)


    def currentDateTime(self, onlyDate=False, wait=False):
        if wait:
            time.sleep(5)

        if onlyDate:
            return datetime.now().strftime("%Y%m%d")
        else:
            return datetime.now().strftime("%Y%m%d%H%M%S")



    def createIfDirNotexists(self,filelist):
        """b
        Checks if files in given list exist in file system. Quits if errors are found
        :param filelist: List of files to check
        :return: None
        """
        for sf in filelist:
            logmsg = 'Creating dir if not exists: ' + sf
            if not path.exists(sf):
                self.writeLog(logmsg)
                subroutine(["mkdir", "-p", sf],self)

            else:
                self.writeLog(logmsg + ' OK')


    def writeLog(self,message):
        self.LOGFILE.write(message + os.linesep + os.linesep)

    def closeResources(self):
        if not self.LOGFILE is None:
            self.LOGFILE.close()

    def newDataAvailable(self):
        try:
            if os.path.isfile(self.SFrawFromHAN + os.sep + "gruen_marcxml.format.xml") \
            and os.path.isfile(self.SFrawFromHAN + os.sep + "orange_marcxml.format.xml"):
                self.writeLog("new content available")
                return True
            else:
                self.writeLog("new content not available")
                return False
        except Exception as exc:
            self.writeLog("Exception was thrown during check for new content")
            self.writeLog("processing won't be started")
            return False

    def moveContentToProcessDir(self):
        if os.path.isfile(self.SFrawFromHAN + os.sep + "gruen_marcxml.format.xml"):
            subroutine(
                ["mv",
                 self.SFrawFromHAN + os.sep + "gruen_marcxml.format.xml",
                 self.SFrawFromHANProcess]
            )

        if os.path.isfile(self.SFrawFromHAN + os.sep + "orange_marcxml.format.xml"):
            subroutine(
                ["mv",
                 self.SFrawFromHAN + os.sep + "orange_marcxml.format.xml",
                 self.SFrawFromHANProcess]
            )

    def moveContentFromProcessDirToArchive(self):
        if os.path.isfile(self.SFrawFromHANProcess + os.sep + "gruen_marcxml.format.xml"):
            subroutine(
                ["mv",
                 self.SFrawFromHANProcess + os.sep + "gruen_marcxml.format.xml",
                 self.SFarchiveFilesFrequent]
            )

        if os.path.isfile(self.SFrawFromHANProcess + os.sep + "orange_marcxml.format.xml"):
            subroutine(
                ["mv",
                 self.SFrawFromHANProcess + os.sep + "orange_marcxml.format.xml",
                 self.SFarchiveFilesFrequent]
            )







def subroutine(arglist, instance = None, cwd='.', ):
    """
    Wraps a call to the run method of package subprocess
    :param arglist: List with command and arguments
    :param cwd: Set working directory
    :return: A CompletedProcess instance
    """
    p = subprocess.run(arglist, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    #how can we do this??
    if not instance is None:
        instance.writeLog(p.stdout.decode("utf-8") )
    return p





if __name__ == '__main__':

    usage = "usage: %prog -g [index green] -o [index orange]  "
    #in case you want to update more than one cluster use the syntax:
    #default='http://sb-us15.swissbib.unibas.ch:8080/solr/green/update###http://sb-whatover:8080/solr/green/update')


    parser = ArgumentParser(usage=usage)
    parser.add_argument('-g', '--green', help='url for index www.swissbib.ch', type=str,
                        default='http://sb-us21.swissbib.unibas.ch:8080/solr/green/update###http://sb-us25.swissbib.unibas.ch.ch:8080/solr/green/update')
    #hier fehlt noch der Fallbackcluster zum Beispiel:
    #default='http://sb-up1.swissbib.unibas.ch/solr/green/update###http://sb-us14.swissbib.unibas.ch:8080/solr/green/update'
    #server stehen noch nicht fest
    parser.add_argument('-o', '--orange', help='Path to logging directory', type=str,
                        default='http://sb-us29.swissbib.unibas.ch:8080/solr/bb/update###http://sb-us32.swissbib.unibas.ch:8080/solr/bb/update')

    parser.add_argument('-f', '--solrfrequent', help='Path to directory structure where frequent updates are processed', type=str,
                        default='/swissbib_index/solrDocumentProcessing/FrequentInitialPreProcessing')

    parser.add_argument('-m', '--marc2solr', help='Path to directory structure where software and data is located', type=str,
                        default='/swissbib_index/solrDocumentProcessing/MarcToSolr')

    parser.add_argument('-z', '--zgreen', help='config file with zookeeper definitions for green',
                        type=str,
                        default='../app.c1c2.properties')
    #hier fehlt noch der Fallbackcluster zum Beispiel:
    #default='http://sb-up1.swissbib.unibas.ch/solr/green/update###http://sb-us14.swissbib.unibas.ch:8080/solr/green/update'
    #server stehen noch nicht fest
    parser.add_argument('-c', '--zorange', help='path to directory which contains files and subdirs with content for green to be indexed',
                        type=str,
                        default='../app.c1c2.bb.properties')

    parser.add_argument('-i', '--greenInput', help='path to directory which contains files and subdirs with content for green to be indexed',
                        type=str,
                        default='/swissbib_index/solrDocumentProcessing/MarcToSolr/data/outputfiles_archivaldata')
    #hier fehlt noch der Fallbackcluster zum Beispiel:
    #default='http://sb-up1.swissbib.unibas.ch/solr/green/update###http://sb-us14.swissbib.unibas.ch:8080/solr/green/update'
    #server stehen noch nicht fest
    parser.add_argument('-j', '--orangeInput', help='path to directory which contains files and subdirs with content for green to be indexed',
                        type=str,
                        default='/swissbib_index/solrDocumentProcessing/MarcToSolr/data/outputfiles_archivaldata/orange_marcxml')


    parser.parse_args()
    args = parser.parse_args()

    processHANdata = ProcessHANForSearchDocs(args)
    processHANdata.writeLog("processing is started at {0}".format(processHANdata.currentDateTime()))
    if processHANdata.newDataAvailable():
        processHANdata.cleanDirectories()
        processHANdata.moveContentToProcessDir()
        processHANdata.processDocuments()
        processHANdata.moveContentFromProcessDirToArchive()
        processHANdata.deleteHANDocsOnIndices()
        processHANdata.sendToSearchServer()

    processHANdata.writeLog("processing is finished at {0}".format(processHANdata.currentDateTime()))
    processHANdata.closeResources()




