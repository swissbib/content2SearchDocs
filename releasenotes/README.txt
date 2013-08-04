

================================================================================================
Welcome to swissbib document processing for SOLR  <http://www.swissbib.org/    www.swissbib.ch>
=================================================================================================


Releasenotes

Version 0.8 Basel 29.3.2012 Guenter Hipler
-------------------------------------------



1) zum ersten mal werden solche Releasenotes der Jar - library dieser Komponente zugefuegt :-)

2) Aktualisierung der abhängigen libraries. In der vorherigen Version wurde noch Tika 0.10 eingesetzt.
In der Zwischenzeit wurde jedoch bereits die version 1.1 veroeffentlicht.

Was bei der Aktualisierung beachtet werden muss:
Tika wird immer noch mit einer aelteren Version von SLFJ ausgeliefert (1.5.6)
Diese Version ist jedoch nicht konmpatibel zu den Anforderungen der SolrJ - Bibliotheken, die fuer den Fall des
Fetchens von bereits vorhanden Volltexten aus einem SOLR-Suchmaschinenindex verwendet werden.
(dieser use case wurde zu Anfang erstellt, da wir noch die Volltexte aus dem FAST INdex extrahierten (fixml - Strukturen)
 und ueber einen SOLR Index abrufbar zur Verfuegung stellten
 Obwohl dieser use case aktuell nicht aktiv und in der Konfiguration deswegen nicht aktiviert wird, moechte ich ihn nicht komplett
 entfernen -womit auch viel weniger Abhaengigkeiten entstehen wuerden- da man diese Moeglichkeit spaeter zur weiteren Anreicherung
 einsetzen koennte (VIAF , MACS etc)

Das Vorgehen zur Erstellung einer brauchbaren Tika-App ist unter http://www.swissbib.org/wiki/index.php?title=Members:Documentprocessing_Tika beschrieben



3) Erweiterung der Konfiguration um die Property HTTP.FETCH.NOT.ALLOWED z.B.
HTTP.FETCH.NOT.ALLOWED=http://opac\.nebis\.ch/objects/pdf/.*?\.pdf

Im Zusammenspiel mit den properties
REMOTEFETCHING=[true|false] und
ALLOWED.DOCUMENTS=http://www\.ub\.unibas\.ch/tox/IDSLUZ/.*?/PDF###http://www\.ub\.unibas\.ch/tox/IDSBB/.*?/PDF###http://www\.ub\.unibas\.ch/tox/HBZ/.*?/OCR###http://d-nb\.info/.*?/04###http://aleph\.unisg\.ch/hsgscan/.*?\.pdf###http://opac\.nebis\.ch/objects/pdf/.*?\.pdf###http://biblio\.unizh\.ch/objects/pdf/.*?\.pdf###http://libraries\.admin\.ch/gw/toc/pdf/.*?\.pdf

ist nun folgender Ablauf möglich:

- mit REMOTEFETCHING=[true|false] wird grundsätzlich der Mechanismus zum Fetchen von remote content ein- oder ausgeschaltet
- ALLOWED.DOCUMENTS definiert, welche patterns überhaupt für das Fetchen von content berücksichtigt werden.

- dann gibt es noch die Properties
#access to database for cached remote content
JDBCDRIVER=com.mysql.jdbc.Driver
#JDBCCONNECTION=jdbc:mysql://sb-util.swissbib.unibas.ch:3306/remotecontent
JDBCCONNECTION=jdbc:mysql://localhost:2000/remotecontent
user=
passwd=

Wird mit JDBCDRIVER=com.mysql.jdbc.Driver ein datenanktreiber angegeben, wird versucht ein connection aufzubauen
(bleibt diese property leer - JDBCDRIVER= - oder ist sie gar nicht vorhanden, ist der DBMS Mechanismus deaktiviert)


Zur Zeit ist es nur möglich, Dokumente vom Fetchen auszuschliessen, wenn das pattern nicht in ALLOWED.DOCUMENTS aufgenommen ist.
Damit wird aber auch nicht mehr in der Datenbank nach möglichem content nachgeschaut :-(

Das kann man mal ändern - im Moment lassen wir das aber mal so.

Temporär hilft die property
HTTP.FETCH.NOT.ALLOWED=http://opac\.nebis\.ch/objects/pdf/.*?\.pdf

mit der man das Fetchen per HTTP 'explizit' unterbinden kann!

todo: hier ist mal ein refactoring nötig! mit der Zeit ist da alles mögliche zusammengekommen

4) Zusammenstellung der abhängigen Dateien

aus solrJ
a) apache-solr-noggit-r1211150.jar (Noggit is a fast streaming JSON parser for Java. neu in 4.0 / https://github.com/Gasol/noggit)
b) commons-codec-1.6.jar (http://commons.apache.org/codec/  Apache Commons Codec (TM) software provides implementations of common encoders and decoders such as Base64, Hex, Phonetic and URLs. )
c) commons-httpclient-3.1.jar
Achtung:
The Commons HttpClient project is now end of life, and is no longer being developed. It has been replaced by the Apache HttpComponents project in its HttpClient and HttpCore modules, which offer better performance and more flexibility.
(das könnte man wohl auch für den "Service gateway" neu in TouchPoint Client verwenden - Availability etc..
d) commons-io-2.1.jar  (Commons IO is a library of utilities to assist with developing IO functionality.)
e) jcl-over-slf4j-1.6.1.jar (commons logging - bracuen wir das??)
f) slf4j-api-1.6.1.jar (SLFJ Facade)
g) wstx-asl-3.2.7.jar (High-performance XML processor - STAX)


Unklar: Ich versteh nicht, warum ich die Jars slf4j-log4j12-1.6.1.jar und log4j-1.2.16.jar nicht benoetige (oberhalb der includierten Verzeichnisse)
-> mit ersterer gib tes einen Bindkonflikt mit JCL in Tika. Aber Log4J scheint von sonst irgendwo herzukommen...




Version 0.8.1 Basel 24.4.2012 Guenter Hipler
-------------------------------------------

1) Wiederaufnahme des regelmässigen Indexupdates
kleinere Anpassungen an scripten und deployment vor und während des Testens


Version 0.8.2 Basel 07.5.2012 Guenter Hipler
-----------------------------------------------

1) erste Integration von Viaf Document processing


Version 0.8.3 Basel 13.7.2012 Guenter Hipler
-----------------------------------------------
1) sb_post2solr_Frequent.sh

es wird jetzt nur noch ein commit -nachdem die Ergebnisse 'aller' nach SOLR geschickt wurden-
abgesetzt - weniger Segmente


Version 0.8.4 Basel 22.7.2012 Guenter Hipler
----------------------------------------------
TikaURLContent Reader: Anpassung des logging. Bisher wurde der Anschein erweckt,
dass einige Dokumente nicht matchen und damit nicht berücksichtigt würden.
Das ist aber nicht der Fall.

tikaNoContentLogger.debug("no match DocID: " + DocId + " / URL; " + url);
tikaNoContentLogger.debug("with pattern: " + p.pattern() + "\n");



Version 0.9, Basel Dezember 2012
------------------------------------------------------------------------------------------
Refactoring der Architektur
Ziele:
die einzelnen Komponenten
a) engine:
 - welche den Ablauf der Umwandlung initiiert
 - die Basis-konfigurationsoptionen (variabel abhängig vom aufrufenden script) für den Prozess entgegennimmt
 - konfigurierte plugins initialisiert
 - die zu Transformierenden Daten aus einem inputfile liest und record für record einer Kette von xslt templates überreicht
  (in dieser Kette findet dann die eigentliche Transformation statt)
 - die transformierten records in ein oder mehrere Ausgabefiles schreibt
 Möglichkeiten für eine weitere Refaktorisierung:
    die hier in Kurform beschriebenen Aufgaben (Lesen von Daten, Schreiben von Daten, Grundinitialisierung)
    könnte noch allgemeiner umgesetzt werden. Das gäbe uns die Möglichkeit, jeweileige Spezialisierungen auf Subkomponenten
    zu verteilen und unterschiedliche Möglichkeiten zu realisieren. (Zum Beispiel könnte die Ein- und Ausgabe aus anderen pipes als nur files erfolgen
    -> vorher jedoch bestehende Frameworks ansehen!

b) Plugins, welche von XSLT-Templates aufgerufen werden
   Diese plugins sollten unabhängiger von der engine implementiert sein.
   Die Initialisierung erfolgt über Konfiguration
   damit zusammenhängend:
    - Konfigurationsoptionen werden nicht mehr durch die engine validiert. Diese sammelt sie nur und übergibt sie ohne weitere Prüfung an die Plugins
    - auch der Übergabemechanismus sollte weniger typgebunden sine
        bisher gab es dafür einen sogenannten ConfigContainer, der sowohö Konfiguarationen als auch Logik enthielt.
        Das führte zu nicht gewollten Abhängigkeiten
   Die Plugins sollten auch unabhängig von der Engine benutze werden können (z.B. FulltextContentEnrichment)
        (dafür müssen sie aber unabhängig von der Engine initialisiert werden können und alle logik zur Initialisierung darf auch nur im plugin
        stattfinden
            todo: hier eventuell noch zu machen: Doppelspurigkeiten zwischen plugins z.B. doppelt instatierter Proxy
c) renaming der Komponenenten z.B.:
    - FulltextContentEnrichment und nicht mehr URLTika .....
    - die engine kann generell XML Strukturen mit den XSLT Templates verarbeiten (und nicht nicht nur MarcXML2SOLR)
    ....

d) Entschlacken der ganzen Sache
    - bisher wurde ein spezieller ArgumentParser verwendet (aus Apache-common). Dies wurde auf java-typischere properties umgestellt
    -> mit dem Nachteil dass scripte angepasst werden müssen


******** Version 0.9.1 Anpassungen der deploy scripte, Basel Januar 2013, GH
------------------------------------------------------------------------------




******** Version 0.9.2 Integration von GND und Viaf (noch nicht abgeschlossen), Basel Januar/Februar 2013, GH
------------------------------------------------------------------------------


********Version 0.9.3, Basel, 6.3.2013
- Anpassung Deployment
- Anpassung engine
-> unterschiedliche Verarbeitung für VuFind und TP (old)
-> bei Vufind werden die Holdings mit in den INdex übernommen, vei TP noch nicht


********Version 0.9.4, Basel, 25.4.2013

- Probleme wenn MongoDB nicht ansprechbar gewesen ist (Prozess brach ab)
-> neu wird dies erkannt und document processing findet nicht statt

- zusätzliches Attribut includeantruntime="false" im build script (Hinweis von ant console)



*************** Version 0.9.6  ***********
Refactoring of the transformation engine

now we can create the Document format for various SearchEngines (actually SOLR and ElasticSearch)
-> better modularization of code

Renaming of the main type
from XML2SOLRDocEngine to XML2SearchDocEngine

because of the changes we need a new property to start the program
 -DTARGET.SEARCHENGINE=org.swissbib.documentprocessing.elasticsearch.XML2ESDocEngine
or
 -DTARGET.SEARCHENGINE=org.swissbib.documentprocessing.elasticsearch.XML2SOLRDocEngine
or
 -DTARGET.SEARCHENGINE=org.swissbib.documentprocessing.elasticsearch.XML2SOLRDocNoHoldingsEngine
  (was needed for the old presentation component TP where holdings weren't stored in the SearchEngine index



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






















