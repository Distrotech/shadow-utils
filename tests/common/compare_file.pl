#!/usr/bin/perl

open (TEMPLATE, $ARGV[0]) or die "Cannot open '".$ARGV[0]."': $!";
my $template = join "", <TEMPLATE>;
open (FILE, $ARGV[1]) or die "Cannot open '".$ARGV[1]."': $!";
my $file = join "", <FILE>;

my $today = int(time()/(24*3600));
$template =~ s/\@TODAY\@/$today/g;

my $tmp = $template;
while ($tmp =~ m/^(.*?)([^\n]*):\@PASS_DES ([^:]*)\@:(.*)$/s) {
	my $user = $2;
	my $pass = $3;
	$tmp = $4;
	if ($file =~ m/^$user:/m) {
	$file =~ s/^$user:([^:]*):(.*)$/$user:\@PASS_DES $pass\@:$2/m;
	my $cryptpass = $1;
	# Check the password
	my $checkpass = qx|/usr/bin/openssl passwd -crypt -salt $cryptpass $pass|;
	chomp $checkpass;

	die "Wrong password: '$cryptpass'. Expected password: '$checkpass'\n"
		if ($checkpass ne $cryptpass);
}

$tmp = $template;
while ($tmp =~ m/^(.*?)([^\n]*):\@PASS_MD5 (.*)\@:(.*)$/s) {
	my $user = $2;
	my $pass = $3;
	$tmp = $4;
	if ($file =~ m/^$user:/m) {
	$file =~ s/^$user:([^:]*):(.*)$/$user:\@PASS_MD5 $pass\@:$2/m;
	my $cryptpass = $1;
	# Check the password
	my $salt = $cryptpass;
	$salt =~ s/^\$1\$//;
	my $checkpass = qx|/usr/bin/openssl passwd -1 -salt '$salt' '$pass'|;
	chomp $checkpass;

	die "Wrong password: '$cryptpass'. Expected password: '$checkpass'\n"
		if ($checkpass ne $cryptpass);
}


exit 0 if ($file =~ m/^\Q$template\E$/s);

print "Files differ.\n";

system "diff", "-au", $ARGV[0], $ARGV[1];

exit 1
