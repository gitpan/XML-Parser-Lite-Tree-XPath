use Test::Simple tests => 10;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;

# http://www.zvon.org/xxl/XPathTutorial/Output/example9.html

my $xml = q!
	<aaa>
		<q />
		<ssss />
		<bb />
		<ccc />
		<dddddddd />
		<eeee />
	</aaa>
!;

$xml =~ s/>\s+</></sg;

my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

my @nodes;

@nodes = $xpath->select_nodes(q!//*[string-length(name()) = 3]!);
ok(scalar(@nodes) == 2);
ok($nodes[0]->{name} eq 'aaa');
ok($nodes[1]->{name} eq 'ccc');

@nodes = $xpath->select_nodes(q!//*[string-length(name()) < 3]!);
ok(scalar(@nodes) == 2);
ok($nodes[0]->{name} eq 'q');
ok($nodes[1]->{name} eq 'bb');

@nodes = $xpath->select_nodes(q!//*[string-length(name()) > 3]!);
ok(scalar(@nodes) == 3);
ok($nodes[0]->{name} eq 'ssss');
ok($nodes[1]->{name} eq 'dddddddd');
ok($nodes[2]->{name} eq 'eeee');

