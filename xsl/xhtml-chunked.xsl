<?xml version='1.0'?> 
<xsl:stylesheet  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"> 

<xsl:import href="../libs/docbook-xsl/docbook-xsl-ns-1.75.0/xhtml-1_1/chunk.xsl"/>
<xsl:import href="../libs/docbook-xsl/docbook-xsl-ns-1.75.0/highlighting/common.xsl"/>
<xsl:import href="../libs/docbook-xsl/docbook-xsl-ns-1.75.0/xhtml-1_1/highlight.xsl"/>

<xsl:param name="html.stylesheet">screen.css style.css</xsl:param>

	<!-- ===== Override to wrap content in extra divs ====-->
	<xsl:template name="chunk-element-content">
	  <xsl:param name="prev"/>
	  <xsl:param name="next"/>
	  <xsl:param name="nav.context"/>
	  <xsl:param name="content">
	    <xsl:apply-imports/>
	  </xsl:param>
	
	  <xsl:call-template name="user.preroot"/>
	
	  <html>
	    <xsl:call-template name="html.head">
	      <xsl:with-param name="prev" select="$prev"/>
	      <xsl:with-param name="next" select="$next"/>
	    </xsl:call-template>
	
	    <body>
	      <div class="container">
			<div class="span-18 push-3">
		      <xsl:call-template name="body.attributes"/>
		      <xsl:call-template name="user.header.navigation"/>
		
		      <xsl:call-template name="header.navigation">
		        <xsl:with-param name="prev" select="$prev"/>
		        <xsl:with-param name="next" select="$next"/>
		        <xsl:with-param name="nav.context" select="$nav.context"/>
		      </xsl:call-template>
		
		      <xsl:call-template name="user.header.content"/>
		
		      <xsl:copy-of select="$content"/>
		
		      <xsl:call-template name="user.footer.content"/>
		
		      <xsl:call-template name="footer.navigation">
		        <xsl:with-param name="prev" select="$prev"/>
		        <xsl:with-param name="next" select="$next"/>
		        <xsl:with-param name="nav.context" select="$nav.context"/>
		      </xsl:call-template>
		
		      <xsl:call-template name="user.footer.navigation"/>
		     </div>
	      </div>
	    </body>
	  </html>
	  <xsl:value-of select="$chunk.append"/>
	</xsl:template>

</xsl:stylesheet>