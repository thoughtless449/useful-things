<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns="http://www.w3.org/1999/xhtml"

    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:arc="http://www.opengroup.org/xsd/archimate/3.0/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:output  method="xhtml" omit-xml-declaration="yes" />  
  
<xsl:template match="/">

<html>
  
  <style>
    body {
        font-family: "Helvetica Neue", "Open Sans", Arial, sans-serif;
    }

 
  </style>
  
  <body>
    <h1><xsl:value-of select="arc:model/arc:name"/></h1>
    <p><xsl:value-of select="arc:model/arc:documentation"/></p>
    
    <h2>Elements in the model</h2>
    <ul>
        <xsl:for-each select="arc:model/arc:elements/arc:element[@xsi:type='TechnologyFunction']">
            <xsl:sort select="@xsi:type"/>
			<li>
				<xsl:value-of select="arc:name"/>
				<xsl:variable name="id"><xsl:value-of select="@identifier"/> </xsl:variable>
				<ul>
				<xsl:call-template name="findReqsForId">
					<xsl:with-param name="id" select="@identifier"/>
				</xsl:call-template>
				</ul>
			</li>
        </xsl:for-each>
    </ul>
        
    
  </body>
</html>

</xsl:template>

<!-- Recursively iterate over relations to find requirements-->

<xsl:template name="findReqsForId" >
	<xsl:param name="id" select="none"/>
	
    <xsl:for-each select="//arc:model/arc:relationships/arc:relationship[@source=$id]">
		<xsl:sort select="@xsi:type"/>
		<xsl:variable name="target" select="@target"/>
		
		<xsl:choose>
			<xsl:when test="//arc:model/arc:elements/arc:element[@identifier=$target]/@xsi:type = 'Requirement'">
				<li> 
					Req: <xsl:value-of select="//arc:model/arc:elements/arc:element[@identifier=$target]/arc:name"/> 
				</li>
			</xsl:when>
			<xsl:otherwise>
			<ul>
			from Subfunction:<xsl:value-of select="//arc:model/arc:elements/arc:element[@identifier=$target]/arc:name"/>
				<xsl:call-template name="findReqsForId">
					<xsl:with-param name="id" select="@target"/>
				</xsl:call-template>
			</ul>
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>