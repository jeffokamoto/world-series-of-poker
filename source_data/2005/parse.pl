#! /usr/bin/perl -w

$PLACE = 1;
$NAME = 2;
$RESIDENCE = 4;
$PAYOUT = 3;

build_state();

open(PAY, ">payout") or die "Can't open payout: $!\n";
open(WHO, ">whodat") or die "Can't open whodat: $!\n";

open(F, $ARGV[0]) or die "Can't open $ARGV[0]: $!\n";

$/ = "</tr>\n";

while ($line1=<F>) {

	# chomp($line1);
	next unless $line1;

	$line1 =~ s/\n//g;
	$line1 =~ s/\s+<td>/<td>/g;

	@a = split(/<[^>]*><[^>]*>/, $line1);

	# print join(':', @a), "\n";
	# $a[$PLACE] =~ s/\D+//g;
	if ($a[$NAME] =~ /\((.*)\)/) {
		$a[$RESIDENCE] = $1;
		$a[$NAME] =~ s/\s+\(.*//;
	}

	$first = $last = $middle = $nick = "";
	@n = split(/\s+/, $a[$NAME]);
	if (@n == 2) {
		($first, $last) = @n;
	} elsif (@n == 3) {
		if ($n[1] =~ /"/) {
			($first, $nick, $last) = @n;
		} else {
			($first, $middle, $last) = @n;
		}
	} elsif (@n == 4) {
		$first = $n[0];
		$nick = "$n[1] $n[2]";
		$last = $n[3];
	} else {
		warn "$a[$NAME] could not be parsed as a name\n";
	}

	$a[$NAME] =~ s/['"]//g;
	$a[$PAYOUT] =~ s/[\$,]//g;
	$a[$PAYOUT] =~ s/\s.*$//g;
	if ($a[$RESIDENCE]) {
		$a[$RESIDENCE] =~ s/[\(\)]//g;
		$a[$RESIDENCE] =~ s/^\s+//g;
		$a[$RESIDENCE] =~ s/\s+$//g;
		$a[$RESIDENCE] = fix_state($a[$RESIDENCE]);
	}

	$id = lc(substr($first, 0, 1) . $last);
	$id =~ s/[\'\-]//g;

	print PAY "    <place>\n";
	print PAY "      <position>$a[$PLACE]</position>\n";
	print PAY "      <player id=\"$id\"/>\n";
	print PAY "      <payout>$a[$PAYOUT]</payout>\n";
	print PAY "    </place>\n";

	print WHO "<person id=\"$id\">\n";
	print WHO "  <first_name>$first</first_name>\n";
	print WHO "  <mid_nick>$nick</mid_nick>\n" if $nick;
	print WHO "  <middle_name>$middle</middle_name>\n" if $middle;
	print WHO "  <last_name>$last</last_name>\n";
	print WHO "  <residence>$a[$RESIDENCE]</residence>\n" if $a[$RESIDENCE];
	print WHO "</person>\n";
	print WHO "\n";
}

close PAY;
close WHO;

exit 0;

sub fix_state {
	my ($residence) = @_;
	foreach $k (keys %states) {
		$v = $states{$k};
		if ($residence =~ s/$k/$v/i) {
			# print STDERR "Changed $k to $v\n";
			last;	# Only once
		}
	}
	return $residence;
}

sub build_state {
	while ($long = <DATA>) {
		$short = <DATA>;
		chomp($long);
		chomp($short);
		$states{$long} = $short;
	}
}
__END__
ALABAMA
AL
ALASKA
AK
ARIZONA
AZ
ARKANSAS
AR
CALIFORNIA
CA
COLORADO
CO
CONNECTICUT
CT
DELAWARE
DE
FLORIDA
FL
GEORGIA
GA
HAWAII
HI
IDAHO
ID
ILLINOIS
IL
INDIANA
IN
IOWA
IA
KANSAS
KS
KENTUCKY
KY
LOUISIANA
LA
MAINE
ME
MARYLAND
MD
MASSACHUSETTS
MA
MICHIGAN
MI
MINNESOTA
MN
MISSISSIPPI
MS
MISSOURI
MO
MONTANA
MT
NEBRASKA
NE
NEVADA
NV
NEW HAMPSHIRE
NH
NEW JERSEY
NJ
NEW MEXICO
NM
NEW YORK
NY
NORTH CAROLINA
NC
NORTH DAKOTA
ND
OHIO
OH
OKLAHOMA
OK
OREGON
OR
PENNSYLVANIA
PA
RHODE ISLAND
RI
SOUTH CAROLINA
SC
SOUTH DAKOTA
SD
TENNESSEE
TN
TEXAS
TX
UTAH
UT
VERMONT
VT
VIRGINIA
VA
WASHINGTON
WA
WEST VIRGINIA
WV
WISCONSIN
WI
WYOMING
WY
