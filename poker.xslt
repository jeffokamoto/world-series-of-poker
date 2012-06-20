<?xml version="1.0"?>
<xsl:stylesheet version="1.1"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">                    <!--root rule-->
<!-- Build the entire chronology of the WSOP -->
<xsl:call-template name="chronology"/>

<!-- Builds the long list of money won per player -->
<xsl:call-template name="player_cashes"/>

<!-- Builds the total  money won per player -->
<xsl:call-template name="player_totals"/>

</xsl:template>




<!-- Template "chronology" builds a list of the entire
     History of the World Series of Poker on a per-year,
     per-event basis.
-->

<xsl:template name="chronology">
<xsl:document href="history.html" method="html" indent="no">
<html>
<head><title>History of the World Series of Poker</title></head>
<body>
<h1>
History of the World Series of Poker
</h1>
<xsl:for-each select="history/world_series">
<xsl:value-of select="number"/> World Series of Poker (<xsl:value-of select="year"/>)
<xsl:value-of select="casino"/>
Total Prize Pool: $<xsl:value-of select="format-number(sum(event_list/event/prize_pool),'###,###,###')"/>
<xsl:if test="notes">
Notes: <xsl:value-of select="notes"/></xsl:if>
<xsl:for-each select="event_list/event">
	Event <xsl:value-of select="event_num"/>: <xsl:value-of select="game"/> <xsl:if test="description"> (<xsl:value-of select="description"/>)</xsl:if>
	Buyin: $<xsl:value-of select="format-number(buyin,'##,###,###')"/>
	<xsl:if test="start_date">
	Date: <xsl:value-of select="start_date"/></xsl:if><xsl:if test="end_date"> - <xsl:value-of select="end_date"/></xsl:if>
	Entrants: <xsl:value-of select="entrants"/><xsl:if test="rebuys"> + <xsl:value-of select="rebuys"/> rebuys</xsl:if>
	Prize Pool: $<xsl:value-of select="format-number(prize_pool,'##,###,###')"/>
<xsl:if test="notes">
	Notes: <xsl:value-of select="notes"/></xsl:if>
	<xsl:for-each select="places/place">
	    Place: <xsl:value-of select="position"/> Name: <xsl:call-template name="get_person"><xsl:with-param name="person_id" select="player/@id"/></xsl:call-template> Prize: $<xsl:value-of select="format-number(payout,'##,###,###')"/>
	</xsl:for-each>
</xsl:for-each>
<xsl:text>

</xsl:text>
</xsl:for-each>
</body>
</html>
</xsl:document>
</xsl:template>



<!-- Template "player_cashes" lists all the times a player
     has cashed in any World Series event.
-->
<xsl:template name="player_cashes">
<xsl:document href="long.html" method="html" indent="no">
<html>
<head><title>World Series of Poker Cashes</title></head>
<body>
<h1>
World Series of Poker Cashes
</h1>
<table border="1">
<tr><th colspan="5">Player</th></tr>
<tr><th>Prize</th><th>Place</th><th>Year</th><th>Game</th><th>Buyin</th></tr>
<xsl:for-each select="history/person">
	<xsl:variable name="this_id" select="@id"/>
	<tr><td colspan="5"><b><xsl:call-template name="get_person_with_residence"><xsl:with-param name="person_id" select="@id"/></xsl:call-template></b>
	($<xsl:value-of select="format-number(sum(//player[@id=$this_id]/following-sibling::payout),'##,###,###')"/>)</td></tr>
	<xsl:text>
</xsl:text>
	<xsl:for-each select="//player[@id=$this_id]">
		<tr><td align="right">$<xsl:value-of select="format-number(following-sibling::payout,'##,###,###')"/></td>
		<td align="right"><xsl:value-of select="preceding-sibling::position"/></td>
		<td><xsl:value-of select="preceding::year[1]"/></td>
		<td><xsl:value-of select="ancestor::event/game"/><xsl:if test="ancestor::event/description"> (<xsl:value-of select="ancestor::event/description"/>)</xsl:if></td>
		<td align="right">$<xsl:value-of select="format-number(ancestor::event/buyin,'##,###,###')"/></td></tr>
		<xsl:text>
</xsl:text>
	</xsl:for-each>
</xsl:for-each>
</table>
</body>
</html>
</xsl:document>
</xsl:template>



<!-- Template "player_totals" computes the total amount of money
     won by a player over the history of the World Series
-->
<xsl:template name="player_totals">
<xsl:document href="sum.html" method="html" indent="no">
<html>
<head><title>World Series of Poker Money Leaders</title></head>
<body>
<h1>
All-Time Money Winners at the World Series of Poker
</h1>
<table border="1">
<tr><th>Player</th><th>Winnings</th></tr>
<xsl:for-each select="history/person">
	<xsl:sort select="sum(document('wsop.xml')//place[player/@id=current()/@id]/payout)" data-type="number" order="descending"/>
	<tr><td><xsl:call-template name="get_person"><xsl:with-param name="person_id" select="@id"/></xsl:call-template></td>
	<td align="right">$<xsl:value-of select="format-number(sum(document('wsop.xml')//place[player/@id=current()/@id]/payout),'###,###,###')"/></td></tr>
	<xsl:text>
</xsl:text>
</xsl:for-each>
</table>
</body>
</html>
</xsl:document>
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


<!-- Template: get_person_with_residence -->
<!-- Converts an id reference into a nicely formatted name string -->

<xsl:template name="get_person_with_residence">
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
    <xsl:if test="residence">
	<xsl:text> (</xsl:text>
	<xsl:value-of select="residence"/>
	<xsl:text>)</xsl:text>
    </xsl:if>
</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
