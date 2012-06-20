#! /usr/bin/perl

# open(PEOPLE, "people.xml") or die "Can't open people.xml: $!\n";
open(SORTED, ">sort.out") or die "Can't open people.sorted: $!\n";

$/ = "";

while ($line = <>) {

	($id) = $line =~ /id=\"(\w+)\"/;
	# print "ID = $id\n";

	if (defined($list{$id})) {
		print STDERR "Duplicate!\n${line}VERSUS\n$list{$id}";
		$line = "<!-- DUPLICATE -->\n" . $line;
	}
	push(@list, [$id, $line]);
	$list{$id} = $line;
}

@sorted = sort {$a->[0] cmp $b->[0]} @list;

for (@sorted) {
	print SORTED $_->[1];
}
