#!/bin/bash

input=the-book-of-recess.xml

base=`pwd`

# Next is a hack for cross-platform win/linux absolute file for Java
absolute=`echo $base | sed 's|/\([a-z]\)/|/\1:/|'`

xalan=libs/xalan/xalan-j_2_7_1
xslthlJar=libs/xslthl/xslthl-2.0.1.jar
xsl=libs/docbook-xsl/docbook-xsl-ns-1.75.0
xslChunked=xsl/xhtml-chunked.xsl
xslAllInOne=xsl/xhtml.xsl
xslFO=xsl/fo.xsl
fop=libs/fop/fop-0.95
outputAllInOne=pub/html/the-book-of-recess.html
outputChunked=pub/html/index.html
outputFO=pub/fo/the-book-of-recess.fo
outputPDF=pub/pdf/the-book-of-recess.pdf

if [ ! -f $xalan/xalan.jar ]; then
	echo "Xalan not found. Run install script: ./scripts/install.sh"
	exit
fi

if [ ! -f $xsl_template ]; then
	echo "XSL stylesheets not found. Run install script: ./scripts/install.sh"
	exit
fi

if [ ! -d "pub" ]; then
	mkdir pub
fi

if [ ! -d "pub/html" ]; then
	mkdir pub/html
fi

if [ ! -d "pub/fo" ]; then
	mkdir pub/fo
fi

if [ ! -d "pub/pdf" ]; then
	mkdir pub/pdf
fi

cp -Rf imgs pub/html
cp style/* pub/html

java \
	-Djava.endorsed.dirs=$xalan  \
    -cp "$xalan/xalan.jar;$xalan/xml-apis.jar;$xalan/xercesImpl.jar;$xsl/extensions/xalan27.jar;$xslthlJar" \
    -Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration \
	 org.apache.xalan.xslt.Process \
    -in $input  \
    -out $outputChunked  \
    -xsl $xslChunked  \
	-param keep.relative.image.uris 0 \
    -param use.extensions 1 \
    -param highlight.xslthl.config "file://$absolute/libs/xslthl/highlighters/xslthl-config.xml" \
    -param highlight.source 1

java \
	-Djava.endorsed.dirs=$xalan  \
    -cp "$xalan/xalan.jar;$xalan/xml-apis.jar;$xalan/xercesImpl.jar;$xsl/extensions/xalan27.jar;$xslthlJar" \
    -Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration \
	org.apache.xalan.xslt.Process \
    -in $input  \
    -out $outputAllInOne  \
    -xsl $xslAllInOne  \
	-param keep.relative.image.uris 0 \
    -param use.extensions 1 \
    -param highlight.xslthl.config "file://$absolute/libs/xslthl/highlighters/xslthl-config.xml" \
    -param highlight.source 1
    
java \
	-Djava.endorsed.dirs=$xalan  \
    -cp "$xalan/xalan.jar;$xalan/xml-apis.jar;$xalan/xercesImpl.jar;$xsl/extensions/xalan27.jar;$xslthlJar" \
    -Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration \
	org.apache.xalan.xslt.Process \
    -in $input  \
    -out $outputFO  \
    -xsl $xslFO  \
    -param use.extensions 1 \
    -param highlight.xslthl.config "file://$absolute/libs/xslthl/highlighters/xslthl-config.xml" \
    -param highlight.source 1

cp -Rf imgs $fop

cd $fop
java \
	-jar "build/fop.jar" \
	-fo ../../../$outputFO -pdf ../../../$outputPDF
	
cd $base

rm -rf $fop/imgs

echo "Published Recess DocBook to $output"