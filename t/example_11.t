use Test::Simple tests => 10;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;
use Data::Dumper;

# http://www.zvon.org/xxl/XPathTutorial/Output/example11.html

my $xml = q!
	<aaa>
		<bbb />
		<ccc />
	</aaa>
!;

$xml =~ s/>\s+</></sg;

my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

my @nodes;

@nodes = $xpath->select_nodes('/aaa');
ok(scalar(@nodes) == 1);
ok($nodes[0]->{name} eq 'aaa');

@nodes = $xpath->select_nodes('/child::aaa');
ok(scalar(@nodes) == 1);
ok($nodes[0]->{name} eq 'aaa');

@nodes = $xpath->select_nodes('/aaa/bbb');
ok(scalar(@nodes) == 1);
ok($nodes[0]->{name} eq 'bbb');

@nodes = $xpath->select_nodes('/child::aaa/child::bbb');
ok(scalar(@nodes) == 1);
ok($nodes[0]->{name} eq 'bbb');

@nodes = $xpath->select_nodes('/child::aaa/bbb');
ok(scalar(@nodes) == 1);
ok($nodes[0]->{name} eq 'bbb');

