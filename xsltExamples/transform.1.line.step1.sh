!#/usr/bin/bash


java -jar $MY_DEVELOP_DEPLOY/document.processing/Marc2SOLR/saxon/saxon9.jar -s one.line.xml -t ../xslt/swissbib.solr.step1.xsl > one.line.intermediate.xml
