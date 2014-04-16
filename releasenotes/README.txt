



*************** Version 1.0  - 2.8.2013   ***************************

first version dedicated to produce explicitly search docs for our new environment (new presentation component based on VuFind2)

 -> a lot of cleanup
 -> a special preparation of the holdings records isn't necessary any more. Functionality executed in the past as part of a so called PredocProcessing component
 (where the holdings processing was done) is now treated in the responsibility of xml2SearchDocEngine
 -> more refactoring of single types. As a result we are now able to integrate specialised types responsible to produce SearchDocs for different SearchServers
 (at the moment SOLR / ElasticSearch)
 -> the new component is compiled especially for Java7 (no support of Java6)

 ideas for / to be done in upcoming releases:
 -> support not only XML documents as raw content (any kind of document should be transformed)
 -> more refactoring (e.g. logging)
 -> refactoring of properties (they are 'historically grown'




 ************ Version 1.0.5  - 15.4.2014 ******

  format the counter of the output files
  Instead of solrout1.xml and solrout100.xml
  solrout000001.xml and solrout000100.xml

  as a result we will get an exact sort while pushing the messages into the search index


******** Version 1.0.5.1  - 16.4.2014 **************
Guenter Hipler

inconsitent formatation - grrr

**********






















