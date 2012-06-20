<?xml version="1.0"?>
<xsl:stylesheet version="1.1"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">                    <!--root rule-->
<!-- Build the entire chronology of the WSOP -->
<xsl:call-template name="chronology"/>

</xsl:template>

<!-- Template "chronology" builds a list of the entire
     History of the World Series of Poker on a per-year,
     per-event basis.
-->

<xsl:template name="chronology">
	<xsl:for-each select="//place">
Place: <xsl:value-of select="position"/> Name: <xsl:call-template name="get_person"><xsl:with-param name="person_id" select="player/@id"/></xsl:call-template> Prize: $<xsl:value-of select="format-number(payout,'##,###,###')"/>
	</xsl:for-each>
</xsl:template>


<!-- Template: get_person -->
<!-- Converts an id reference into a nicely formatted name string -->

<xsl:template name="get_person">
<xsl:param name="person_id"/>
<xsl:for-each select="//person[@id=$person_id]">
    <xsl:if test="title">
	<xsl:value-of select="title"/>
	<xsl:text> </xsl:text>
    </xsl:if>
    <xsl:if test="pre_nick">
	<xsl:text>&quot;</xsl:text>
	<xsl:value-of select="pre_nick"/>
	<xsl:text>&quot; </xsl:text>
    </xsl:if>
    <xsl:if test="first_name">
	<xsl:value-of select="first_name"/>
	<xsl:text> </xsl:text>
    </xsl:if>
    <xsl:if test="middle_name">
	<xsl:value-of select="middle_name"/>
	<xsl:text> </xsl:text>
    </xsl:if>
    <xsl:if test="mid_nick">
	<xsl:text>&quot;</xsl:text>
	<xsl:value-of select="mid_nick"/>
	<xsl:text>&quot; </xsl:text>
    </xsl:if>
	<xsl:value-of select="last_name"/>
    <xsl:if test="suffix">
	<xsl:text> </xsl:text>
	<xsl:value-of select="suffix"/>
    </xsl:if>
</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
